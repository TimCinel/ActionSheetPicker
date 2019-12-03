"use strict";

var pify = require('pify');

var request = pify(require('request'));

function getRequestHeaders(optionalPrivateToken) {
  if (optionalPrivateToken === void 0) {
    optionalPrivateToken = '';
  }

  var requestHeaders = {
    'User-Agent': 'request'
  };

  if (optionalPrivateToken && optionalPrivateToken.length > 0) {
    requestHeaders.Authorization = `token ${optionalPrivateToken}`;
  }

  return requestHeaders;
}

function getNextLink(link) {
  if (!link) {
    return null;
  }

  var nextLink = link.split(',').find(function (s) {
    return s.includes('rel="next"');
  });

  if (!nextLink) {
    return null;
  }

  return nextLink.split(';')[0].slice(1, -1);
}

function getContributorsPage(url, optionalPrivateToken) {
  return request.get({
    url,
    headers: getRequestHeaders(optionalPrivateToken)
  }).then(function (res) {
    var body = JSON.parse(res.body);

    if (res.statusCode >= 400) {
      if (res.statusCode === 404) {
        throw new Error('No contributors found on the GitHub repository');
      }

      throw new Error(body.message);
    }

    var contributorsIds = body.map(function (contributor) {
      return contributor.login;
    });
    var nextLink = getNextLink(res.headers.link);

    if (nextLink) {
      return getContributorsPage(nextLink).then(function (nextContributors) {
        return contributorsIds.concat(nextContributors);
      });
    }

    return contributorsIds;
  });
}

var getUserInfo = function (username, hostname, optionalPrivateToken) {
  /* eslint-disable complexity */
  if (!hostname) {
    hostname = 'https://github.com';
  }

  if (!username) {
    throw new Error(`No login when adding a contributor. Please specify a username.`);
  }

  var root = hostname.replace(/:\/\//, '://api.');
  return request.get({
    url: `${root}/users/${username}`,
    headers: getRequestHeaders(optionalPrivateToken)
  }).then(function (res) {
    var body = JSON.parse(res.body);
    var profile = body.blog || body.html_url; // Github throwing specific errors as 200...

    if (!profile && body.message) {
      throw new Error(`Login not found when adding a contributor for username - ${username}.`);
    }

    profile = profile.startsWith('http') ? profile : `http://${profile}`;
    return {
      login: body.login,
      name: body.name || username,
      avatar_url: body.avatar_url,
      profile
    };
  });
};

var getContributors = function (owner, name, hostname, optionalPrivateToken) {
  if (!hostname) {
    hostname = 'https://github.com';
  }

  var root = hostname.replace(/:\/\//, '://api.');
  return getContributorsPage(`${root}/repos/${owner}/${name}/contributors?per_page=100`, optionalPrivateToken);
};

module.exports = {
  getUserInfo,
  getContributors
};