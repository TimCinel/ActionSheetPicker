"use strict";

// All Contributors Node JS API
// This is not yet ready for main-stream usage, API implementation may change at any time without warning
// This is to support adding contributors using the AllContributors GitHub Bot (see github.com/all-contributors/all-contributors-bot
// These Node API's are intended to be network and side effect free, everything should be in memory with no io to network/disk
var chalk = require('chalk');

var addContributorWithDetails = require('./contributors/addWithDetails');

var generate = require('./generate');

var _require = require('./init/init-content'),
    addContributorsList = _require.addContributorsList,
    addBadge = _require.addBadge;

process.stdout.write(chalk.yellow(`${chalk.bold('WARNING')} :: Using the all-contributors node-api comes with zero guarantees of stability and may contain breaking changes without warning\n`));
module.exports = {
  addContributorWithDetails,
  generate,
  initContributorsList: addContributorsList,
  initBadge: addBadge
};