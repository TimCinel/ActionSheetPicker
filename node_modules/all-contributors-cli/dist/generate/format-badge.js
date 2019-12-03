"use strict";

var _ = require('lodash/fp');

var defaultTemplate = '[![All Contributors](https://img.shields.io/badge/all_contributors-<%= contributors.length %>-orange.svg?style=flat-square)](#contributors-)';

module.exports = function (options, contributors) {
  return _.template(options.badgeTemplate || defaultTemplate)({
    contributors
  });
};