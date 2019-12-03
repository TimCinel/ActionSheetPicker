"use strict";

var conventions = {
  angular: {
    name: 'Angular',
    msg: 'docs:',
    lowercase: true,

    transform(msg) {
      return msg.replace(/(^.*?) ([A-Z][a-z]+) \w*/, function () {
        for (var _len = arguments.length, words = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
          words[_key - 1] = arguments[_key];
        }

        return `${words[0]} ${words[1].toLowerCase()} `;
      });
    }

  },
  atom: {
    name: 'Atom',
    msg: ':memo:'
  },
  gitmoji: {
    name: 'Gitmoji',
    msg: ':busts_in_silhouette:'
  },
  ember: {
    name: 'Ember',
    msg: '[DOC canary]'
  },
  eslint: {
    name: 'ESLint',
    msg: 'Docs:'
  },
  jshint: {
    name: 'JSHint',
    msg: '[[DOCS]]'
  },
  none: {
    name: 'None',
    msg: ''
  }
};
Object.keys(conventions).forEach(function (style) {
  conventions[style].value = style;
});
module.exports = conventions;