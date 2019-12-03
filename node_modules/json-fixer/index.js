const chalk = require('chalk')
const {parse} = require('./src/json.pjs')
const {psw, removeLinebreak} = require('./src/utils')
const fixer = require('./src/fixer')

let fixRounds = 0
let roundThreshold = 20

const setFixThreshold = data => {
  const lineCount = data.split('\n').length
  roundThreshold = Math.max(data.length / lineCount, lineCount)
}

const doubleCheck = (data, verbose = false) => {
  /* eslint-disable no-console */
  try {
    const res = parse(data)
    psw(`\n${chalk.cyan('The JSON data was fixed!')}`)
    if (res) return res
  } catch (err) {
    if (verbose) {
      psw('Nearly fixed data:')
      data.split('\n').forEach((l, i) => psw(`${chalk.yellow(i)} ${l}`))
    }
    // eslint-disable-next-line no-use-before-define
    if (fixRounds < roundThreshold) return fixJson(err, data, verbose)
    console.error(chalk.red(`There's still an error!`))
    throw new Error(err.message)
  }
  /* eslint-enable no-console */
}

const extraChar = err =>
  err.expected[0].type === 'other' && ['}', ']'].includes(err.found)

const trailingChar = err => {
  const literal =
    err.expected[0].type === 'literal' && err.expected[0].text !== ':'
  return (
    ['.', ',', 'x', 'b', 'o'].includes(err.found) &&
    (err.expected[0].type === 'other' || literal)
  )
}

const missingChar = err =>
  err.expected[0].text === ',' && ['"', '[', '{'].includes(err.found)

const singleQuotes = err => err.found === "'"

const missingQuotes = err =>
  /\w/.test(err.found) && err.expected.find(el => el.description === 'string')

const notSquare = err =>
  err.found === ':' && [',', ']'].includes(err.expected[0].text)

const notCurly = err => err.found === ',' && err.expected[0].text === ':'

const comment = err => err.found === '/'

const ops = err =>
  ['+', '-', '*', '/', '>', '<', '~', '|', '&', '^'].includes(err.found)

/*eslint-disable no-console */
const fixJson = (err, data, verbose) => {
  ++fixRounds
  const lines = data.split('\n')
  if (verbose) {
    psw(`Data:`)
    lines.forEach((l, i) => psw(`${chalk.yellow(i)} ${l}`))
    psw(chalk.red('err='))
    console.dir(err)
  }
  const start = err.location.start
  let fixedData = [...lines]
  const targetLine = start.line - 2

  if (extraChar(err)) {
    fixedData = fixer.fixExtraChar({fixedData, verbose, targetLine})
  } else if (trailingChar(err)) {
    fixedData = fixer.fixTrailingChar({start, fixedData, verbose})
  } else if (missingChar(err)) {
    if (verbose) psw(chalk.magenta('Missing character'))
    const brokenLine = removeLinebreak(lines[targetLine])
    fixedData[targetLine] = `${brokenLine},`
  } else if (singleQuotes(err)) {
    fixedData = fixer.fixSingleQuotes({start, fixedData, verbose})
  } else if (missingQuotes(err)) {
    fixedData = fixer.fixMissingQuotes({start, fixedData, verbose})
  } else if (notSquare(err)) {
    fixedData = fixer.fixSquareBrackets({start, fixedData, verbose, targetLine})
  } else if (notCurly(err)) {
    fixedData = fixer.fixCurlyBrackets({fixedData, verbose, targetLine})
  } else if (comment(err)) {
    fixedData = fixer.fixComment({start, fixedData, verbose})
  } else if (ops(err)) {
    fixedData = fixer.fixOpConcat({start, fixedData, verbose})
  } else
    throw new Error(
      `Unsupported issue: ${err.message} (please open an issue at the repo)`,
    )
  return doubleCheck(fixedData.join('\n'), verbose)
}
/*eslint-enable no-console */

/**
 * @param {string} data JSON string data to check (and fix).
 * @param {boolean} [verbose=false] Verbosity
 * @returns {{data: (Object|string|Array), changed: boolean}} Result
 */
const checkJson = (data, verbose = false) => {
  //inspired by https://jsontuneup.com/
  try {
    const res = parse(data)
    if (res) {
      return {
        data: res,
        changed: false,
      }
    }
  } catch (err) {
    fixRounds = 0
    setFixThreshold(data)
    return {
      data: fixJson(err, data, verbose),
      changed: true,
    }
  }
}

module.exports = checkJson
