"use strict";

var fs = require('fs');

module.exports = function (file) {
  return new Promise(function (resolve, reject) {
    if (fs.existsSync(file)) return resolve(file);
    fs.writeFile(file, '', function (err) {
      if (err) reject(err);
      resolve(file);
    });
  });
};