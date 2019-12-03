"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

var _extends2 = _interopRequireDefault(require("@babel/runtime/helpers/extends"));

var path = require('path');

var spawn = require('child_process').spawn;

var _ = require('lodash/fp');

var pify = require('pify');

var conventions = require('../init/commit-conventions');

var _require = require('./config-file'),
    readConfig = _require.readConfig;

var commitTemplate = '<%= prefix %> <%= (newContributor ? "Add" : "Update") %> @<%= username %> as a contributor';
var getRemoteOriginData = pify(function (cb) {
  var output = '';
  var git = spawn('git', 'config --get remote.origin.url'.split(' '));
  git.stdout.on('data', function (data) {
    output += data;
  });
  git.stderr.on('data', cb);
  git.on('close', function () {
    cb(null, output);
  });
});

function parse(originUrl) {
  var result = /:(\w+)\/([A-Za-z0-9-_]+)/.exec(originUrl);

  if (!result) {
    return null;
  }

  return {
    projectOwner: result[1],
    projectName: result[2]
  };
}

function getRepoInfo() {
  return getRemoteOriginData().then(parse);
}

var spawnGitCommand = pify(function (args, cb) {
  var git = spawn('git', args);
  var bufs = [];
  git.stderr.on('data', function (buf) {
    return bufs.push(buf);
  });
  git.on('close', function (code) {
    if (code) {
      var msg = Buffer.concat(bufs).toString() || `git ${args.join(' ')} - exit code: ${code}`;
      cb(new Error(msg));
    } else {
      cb(null);
    }
  });
});

function commit(options, data) {
  var files = options.files.concat(options.config);
  var absolutePathFiles = files.map(function (file) {
    return path.resolve(process.cwd(), file);
  });
  var config = readConfig(options.config);
  var commitConvention = conventions[config.commitConvention];
  return spawnGitCommand(['add'].concat(absolutePathFiles)).then(function () {
    var commitMessage = _.template(options.commitTemplate || commitTemplate)((0, _extends2.default)({}, data, {
      prefix: commitConvention.msg
    }));

    if (commitConvention.lowercase) commitMessage = commitConvention.transform(commitMessage);
    return spawnGitCommand(['commit', '-m', commitMessage]);
  });
}

module.exports = {
  commit,
  getRepoInfo
};