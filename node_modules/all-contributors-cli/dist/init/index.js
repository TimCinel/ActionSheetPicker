"use strict";

var util = require('../util');

var prompt = require('./prompt');

var initContent = require('./init-content');

var ensureFileExists = require('./file-exist');

var configFile = util.configFile;
var markdown = util.markdown;

function injectInFile(file, fn) {
  return markdown.read(file).then(function (content) {
    return markdown.write(file, fn(content));
  });
}

module.exports = function () {
  return prompt().then(function (result) {
    return configFile.writeConfig('.all-contributorsrc', result.config).then(function () {
      ensureFileExists(result.contributorFile);
    }).then(function () {
      return injectInFile(result.contributorFile, initContent.addContributorsList);
    }).then(function () {
      if (result.badgeFile) {
        return injectInFile(result.badgeFile, initContent.addBadge);
      }
    });
  });
};