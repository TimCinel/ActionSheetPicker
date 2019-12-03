"use strict";

var _ = require('lodash/fp');

var inquirer = require('inquirer');

var util = require('../util');

var repo = require('../repo');

var contributionChoices = _.flow(util.contributionTypes, _.toPairs, _.sortBy(function (pair) {
  return pair[1].description;
}), _.map(function (pair) {
  return {
    name: `${pair[1].symbol}  ${pair[1].description}`,
    value: pair[0]
  };
}));

function getQuestions(options, username, contributions) {
  return [{
    type: 'input',
    name: 'username',
    message: `What is the contributor's ${repo.getTypeName(options.repoType)} username?`,
    when: !username,
    validate: function (input) {
      if (!input) {
        return 'Username not provided';
      }

      return true;
    }
  }, {
    type: 'checkbox',
    name: 'contributions',
    message: 'What are the contribution types?',
    when: !contributions,
    default: function _default(answers) {
      // default values for contributions when updating existing users
      answers.username = answers.username || username;
      return options.contributors.filter(function (entry) {
        return entry.login && entry.login.toLowerCase() === answers.username.toLowerCase();
      }).reduce(function (allEntries, entry) {
        return allEntries.concat(entry.contributions);
      }, []);
    },
    choices: contributionChoices(options),
    validate: function validate(input, answers) {
      answers.username = answers.username || username;
      var previousContributions = options.contributors.filter(function (entry) {
        return entry.login && entry.login.toLowerCase() === answers.username.toLowerCase();
      }).reduce(function (allEntries, entry) {
        return allEntries.concat(entry.contributions);
      }, []);

      if (!input.length) {
        return 'Use space to select at least one contribution type.';
      } else if (_.isEqual(input, previousContributions)) {
        return 'Nothing changed, use space to select contribution types.';
      }

      return true;
    }
  }];
}

function getValidUserContributions(options, contributions) {
  var validContributionTypes = util.contributionTypes(options);
  var userContributions = contributions && contributions.split(',');

  var validUserContributions = _.filter(function (userContribution) {
    return validContributionTypes[userContribution] !== undefined;
  })(userContributions);

  var invalidUserContributions = _.filter(function (userContribution) {
    return validContributionTypes[userContribution] === undefined;
  })(userContributions);

  if (_.isEmpty(validUserContributions)) {
    throw new Error(`${invalidUserContributions.toString()} is/are invalid contribution type(s)`);
  }

  return validUserContributions;
}

module.exports = function (options, username, contributions) {
  var defaults = {
    username,
    contributions: username === undefined && contributions === undefined ? [] : getValidUserContributions(options, contributions)
  };
  var questions = getQuestions(options, username, contributions);
  return inquirer.prompt(questions).then(_.assign(defaults));
};