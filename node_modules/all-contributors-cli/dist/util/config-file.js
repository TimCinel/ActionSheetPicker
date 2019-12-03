"use strict";

var fs = require('fs');

var pify = require('pify');

var _ = require('lodash/fp');

var jf = require('json-fixer');

function readConfig(configPath) {
  try {
    var _jf = jf(fs.readFileSync(configPath, 'utf-8')),
        config = _jf.data,
        changed = _jf.changed;

    if (!('repoType' in config)) {
      config.repoType = 'github';
    }

    if (!('commitConvention' in config)) {
      config.commitConvention = 'none';
    }

    if (changed) {
      //Updates the file with fixes
      fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    }

    return config;
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw new SyntaxError(`Configuration file has malformed JSON: ${configPath}. Error:: ${error.message}`);
    }

    if (error.code === 'ENOENT') {
      throw new Error(`Configuration file not found: ${configPath}`);
    }

    throw error;
  }
}

function writeConfig(configPath, content) {
  if (!content.projectOwner) {
    throw new Error(`Error! Project owner is not set in ${configPath}`);
  }

  if (!content.projectName) {
    throw new Error(`Error! Project name is not set in ${configPath}`);
  }

  if (content.files && !content.files.length) {
    throw new Error(`Error! Project files was overridden and is empty in ${configPath}`);
  }

  return pify(fs.writeFile)(configPath, `${JSON.stringify(content, null, 2)}\n`);
}

function writeContributors(configPath, contributors) {
  var config;

  try {
    config = readConfig(configPath);
  } catch (error) {
    return Promise.reject(error);
  }

  var content = _.assign(config, {
    contributors
  });

  return writeConfig(configPath, content);
}

module.exports = {
  readConfig,
  writeConfig,
  writeContributors
};