"use strict";

var _ = require('lodash/fp');

function uniqueTypes(contribution) {
  return contribution.type || contribution;
}

function formatContributions(options, existing, types) {
  if (existing === void 0) {
    existing = [];
  }

  var same = _.intersectionBy(uniqueTypes, existing, types);

  var remove = types.length < existing.length && same.length;

  if (options.url) {
    return existing.concat(types.map(function (type) {
      return {
        type,
        url: options.url
      };
    }));
  }

  if (remove) {
    return same;
  }

  return _.uniqBy(uniqueTypes, existing.concat(types));
}

function updateContributor(options, contributor, contributions) {
  return _.assign(contributor, {
    contributions: formatContributions(options, contributor.contributions, contributions)
  });
}

function updateExistingContributor(options, username, contributions) {
  return options.contributors.map(function (contributor) {
    if (!contributor.login || username.toLowerCase() !== contributor.login.toLowerCase()) {
      return contributor;
    }

    return updateContributor(options, contributor, contributions);
  });
}

function addNewContributor(options, username, contributions, infoFetcher) {
  return infoFetcher(username, options.repoType, options.repoHost).then(function (userData) {
    var contributor = _.assign(userData, {
      contributions: formatContributions(options, [], contributions)
    });

    return options.contributors.concat(contributor);
  });
}

module.exports = function (options, username, contributions, infoFetcher) {
  // case insensitive find
  var exists = _.find(function (contributor) {
    return contributor.login && contributor.login.toLowerCase() === username.toLowerCase();
  }, options.contributors);

  if (exists) {
    return Promise.resolve(updateExistingContributor(options, username, contributions));
  }

  return addNewContributor(options, username, contributions, infoFetcher);
};