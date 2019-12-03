"use strict";

var _ = require('lodash/fp');

var util = require('../util');

var repo = require('../repo');

var add = require('./add');

var prompt = require('./prompt');

function isNewContributor(contributorList, username) {
  return !_.find({
    login: username
  }, contributorList);
}

module.exports = function (options, username, contributions) {
  var answersP = prompt(options, username, contributions);
  var contributorsP = answersP.then(function (answers) {
    return add(options, answers.username, answers.contributions, repo.getUserInfo);
  });
  var writeContributorsP = contributorsP.then(function (contributors) {
    return util.configFile.writeContributors(options.config, contributors);
  });
  return Promise.all([answersP, contributorsP, writeContributorsP]).then(function (res) {
    var answers = res[0];
    var contributors = res[1];
    return {
      username: answers.username,
      contributions: answers.contributions,
      contributors,
      newContributor: isNewContributor(options.contributors, answers.username)
    };
  });
};