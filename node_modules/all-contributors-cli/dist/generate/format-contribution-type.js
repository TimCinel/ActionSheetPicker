"use strict";

var _ = require('lodash/fp');

var util = require('../util');

var linkTemplate = _.template('<a href="<%= url %>" title="<%= description %>"><%= symbol %></a>');

function getType(options, contribution) {
  var types = util.contributionTypes(options);
  return types[contribution.type || contribution];
}

module.exports = function (options, contributor, contribution) {
  var type = getType(options, contribution);

  if (!type) {
    throw new Error(`Unknown contribution type ${contribution} for contributor ${contributor.login || contributor.name}`);
  }

  var templateData = {
    symbol: type.symbol,
    description: type.description,
    contributor,
    options
  };
  var url = getUrl(contribution, contributor);

  if (contribution.url) {
    url = contribution.url;
  } else if (type.link) {
    url = _.template(type.link)(templateData);
  }

  return linkTemplate(_.assign({
    url
  }, templateData));
};

function getUrl(contribution, contributor) {
  if (contributor.login) {
    return `#${contribution}-${contributor.login}`;
  } else {
    return `#${contribution}`;
  }
}