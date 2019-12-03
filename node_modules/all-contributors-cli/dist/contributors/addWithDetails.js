"use strict";

var addContributor = require('./add'); // Adds a contributor without going to the network (you supply the additional fields)


module.exports = function (_ref) {
  var options = _ref.options,
      login = _ref.login,
      contributions = _ref.contributions,
      name = _ref.name,
      avatar_url = _ref.avatar_url,
      profile = _ref.profile;
  return addContributor(options, login, contributions, function infoFetcherNoNetwork() {
    return Promise.resolve({
      login,
      name,
      avatar_url,
      profile
    });
  });
};