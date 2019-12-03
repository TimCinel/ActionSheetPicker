<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [json-fixer](#json-fixer)
  - [Usage](#usage)
  - [Contributors](#contributors)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# json-fixer

[![NPM](https://nodei.co/npm/json-fixer.png)](https://nodei.co/npm/json-fixer/)

[![GitHub package version](https://img.shields.io/github/package-json/v/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer)
[![devDependencies Status](https://david-dm.org/berkmann18/json-fixer/dev-status.svg)](https://david-dm.org/berkmann18/json-fixer?type=dev)
[![dependencies Status](https://david-dm.org/berkmann18/json-fixer/status.svg)](https://david-dm.org/berkmann18/json-fixer)

[![GH Downloads](https://img.shields.io/github/downloads/Berkmann18/json-fixer/total.svg)](https://github.com/Berkmann18/json-fixer/network/members)
[![GitHub commit activity the past year](https://img.shields.io/github/commit-activity/y/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer/graphs/commit-activity)
[![GitHub contributors](https://img.shields.io/github/contributors/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer/graphs/contributors)
[![Github search hit counter](https://img.shields.io/github/search/Berkmann18/json-fixer/goto.svg)](https://github.com/Berkmann18/json-fixer/graphs/traffic)

[![Build Status](https://travis-ci.org/Berkmann18/json-fixer.svg?branch=master)](https://travis-ci.org/Berkmann18/json-fixer)
[![codecov.io Code Coverage](https://img.shields.io/codecov/c/github/Berkmann18/json-fixer.svg?maxAge=2592000)](https://codecov.io/github/Berkmann18/json-fixer?branch=master)
[![tested with jest](https://img.shields.io/badge/tested_with-jest-99424f.svg)](https://github.com/facebook/jest)
[![Known Vulnerabilities](https://snyk.io/test/github/Berkmann18/json-fixer/badge.svg?targetFile=package.json)](https://snyk.io/test/github/Berkmann18/json-fixer?targetFile=package.json)

[![GitHub](https://img.shields.io/github/license/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer/blob/master/LICENSE)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/Berkmann18/json-fixer/issues)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

[![GitHub top language](https://img.shields.io/github/languages/top/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer)
[![GitHub language count](https://img.shields.io/github/languages/count/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/Berkmann18/json-fixer.svg)](https://github.com/Berkmann18/json-fixer)

[![BCH compliance](https://bettercodehub.com/edge/badge/Berkmann18/json-fixer?branch=master)](https://bettercodehub.com/results/Berkmann18/json-fixer)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2a8e3e98d3bb47f29abbc3df7174675d)](https://app.codacy.com/app/maxieberkmann/json-fixer?utm_source=github.com&utm_medium=referral&utm_content=Berkmann18/json-fixer&utm_campaign=Badge_Grade_Dashboard)

A JSON file fixer primarly focused to be used in a NodeJS file.

## Usage

- In NodeJS

```js
const jsonFix = require('json-fixer')
const fs = require('fs')

// Get the (potentially malformed) JSON data ready
const jsonContent = fs.readFileSync('config.json', 'utf-8')

const {data, changed} = jsonFix(jsonContent) // Lint (and fix) it

if (changed) {
  // Do something with `data` which is the fixed JSON parsed data from `jsonContent`
  // e.g. `fs.writeFileSync(configPath, JSON.stringify(data, null, 2))`
}
```

- In the CLI<br>
  _Not supported yet_ (PR welcome).

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table>
  <tr>
    <td align="center"><a href="http://maxcubing.wordpress.com"><img src="https://avatars0.githubusercontent.com/u/8260834?v=4" width="100px;" alt="Maximilian Berkmann"/><br /><sub><b>Maximilian Berkmann</b></sub></a><br /><a href="https://github.com/Berkmann18/json-fixer/commits?author=Berkmann18" title="Code">💻</a> <a href="https://github.com/Berkmann18/json-fixer/commits?author=Berkmann18" title="Documentation">📖</a> <a href="#ideas-Berkmann18" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-Berkmann18" title="Maintenance">🚧</a> <a href="https://github.com/Berkmann18/json-fixer/commits?author=Berkmann18" title="Tests">⚠️</a></td>
    <td align="center"><a href="http://semantic-release.org/"><img src="https://avatars1.githubusercontent.com/u/32174276?v=4" width="100px;" alt="Semantic Release Bot"/><br /><sub><b>Semantic Release Bot</b></sub></a><br /><a href="#platform-semantic-release-bot" title="Packaging/porting to new platform">📦</a> <a href="https://github.com/Berkmann18/json-fixer/commits?author=semantic-release-bot" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/apps/all-contributors"><img src="https://avatars1.githubusercontent.com/u/649578?v=4" width="100px;" alt="all-contributors[bot]"/><br /><sub><b>all-contributors[bot]</b></sub></a><br /><a href="https://github.com/Berkmann18/json-fixer/commits?author=all-contributors[bot]" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/Bkucera"><img src="https://avatars0.githubusercontent.com/u/14625260?v=4" width="100px;" alt="Ben Kucera"/><br /><sub><b>Ben Kucera</b></sub></a><br /><a href="https://github.com/Berkmann18/json-fixer/commits?author=Bkucera" title="Code">💻</a></td>
  </tr>
</table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
