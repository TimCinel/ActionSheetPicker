const psw = data => process.stdout.write(`${data}\n`)

const removeLinebreak = line => line.replace(/[\n\r]/g, '')

const replaceChar = (str, idx, chr) =>
  str.substring(0, idx) + chr + str.substring(idx + 1)

module.exports = {psw, removeLinebreak, replaceChar}
