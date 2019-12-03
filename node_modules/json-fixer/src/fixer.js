const chalk = require('chalk')
const {psw, removeLinebreak, replaceChar} = require('./utils')
const {parse} = require('./json.pjs')

const fixExtraChar = ({fixedData, verbose, targetLine}) => {
  if (verbose) psw(chalk.magenta('Extra character'))
  if (fixedData[targetLine] === '') --targetLine
  const brokenLine = removeLinebreak(fixedData[targetLine])

  let fixedLine = brokenLine.trimEnd()
  fixedLine = fixedLine.substr(0, fixedLine.length - 1)
  fixedData[targetLine] = fixedLine
  return fixedData
}

const fixSingleQuotes = ({start, fixedData, verbose}) => {
  if (verbose) psw(chalk.magenta('Single quotes'))
  const targetLine = start.line - 1
  const brokenLine = removeLinebreak(fixedData[targetLine])
  const fixedLine = brokenLine.replace(/(":\s*)'(.*?)'/g, '$1"$2"')
  fixedData[targetLine] = fixedLine
  return fixedData
}

const fixTrailingChar = ({start, fixedData, verbose}) => {
  if (verbose) psw(chalk.magenta('Trailing character'))
  const targetLine = start.line - 1
  const brokenLine = removeLinebreak(fixedData[targetLine])
  const fixedLine = brokenLine.replace(/(":\s*)[.,](\d*)/g, '$10.$2')
  const unquotedWord = /(":\s*)(\S*)/g.exec(fixedLine)
  if (unquotedWord) {
    const NN = Number.isNaN(Number(unquotedWord[2]))
    if (NN && !/([xbo][0-9a-fA-F]+)/g.test(unquotedWord[2])) {
      if (verbose) psw(chalk.magenta('Adding quotes...'))
      fixedData[targetLine] = fixedLine.replace(/(":\s*)(\S*)/g, '$1"$2"')
      return fixedData
    }
    if (!NN && !/\0([xbo][0-9a-fA-F]+)/g.test(unquotedWord[2])) {
      if (verbose) {
        psw(
          chalk.cyan(
            "Found a non base-10 number and since JSON doesn't support those numbers types. I will turn it into a base-10 number to keep the structure intact",
          ),
        )
      }
      fixedData[targetLine] = fixedLine.replace(
        unquotedWord[2],
        Number(unquotedWord[2]),
      )
      return fixedData
    }
  }
  let baseNumber = fixedLine.replace(/(":\s*)([xbo][0-9a-fA-F]*)/g, '$1"0$2"')
  if (baseNumber !== fixedLine) {
    if (verbose) {
      psw(
        chalk.cyan(
          "Found a non base-10 number and since JSON doesn't support those numbers types. I will turn it into a base-10 number to keep the structure intact",
        ),
      )
    }
    baseNumber = baseNumber.replace(/"(0[xbo][0-9a-fA-F]*)"/g, (_, num) =>
      Number(num),
    ) //base-(16|2|8) -> base-10
  }

  fixedData[targetLine] = baseNumber
  return fixedData
}

const fixMissingQuotes = ({start, fixedData, verbose}) => {
  if (verbose) psw(chalk.magenta('Missing quotes'))
  const targetLine = start.line - 1
  const brokenLine = removeLinebreak(fixedData[targetLine])
  const NO_RH_QUOTES = /(":\s*)([^,{}[\]]+)/g
  const NO_LH_QUOTES = /(^[^"]\S[\S\s]+)(:\s*["\w{[])/g
  let fixedLine = NO_RH_QUOTES.test(brokenLine)
    ? brokenLine.replace(NO_RH_QUOTES, '$1"$2"')
    : brokenLine
  const leftSpace = fixedLine.match(/^(\s+)/)
  fixedLine = fixedLine.trimStart()
  if (NO_LH_QUOTES.test(fixedLine))
    fixedLine = fixedLine.replace(NO_LH_QUOTES, '"$1"$2')
  fixedData[targetLine] = `${
    leftSpace === null ? '' : leftSpace[0]
  }${fixedLine}`
  return fixedData
}

const fixSquareBrackets = ({start, fixedData, verbose, targetLine}) => {
  if (verbose) psw(chalk.magenta('Square brackets instead of curly ones'))
  const brokenLine = removeLinebreak(
    fixedData[targetLine].includes('[')
      ? fixedData[targetLine]
      : fixedData[++targetLine],
  )
  const fixedLine = replaceChar(brokenLine, start.column - 1, '{')
  fixedData[targetLine] = fixedLine

  try {
    parse(fixedData.join('\n'))
  } catch (e) {
    targetLine = e.location.start.line - 1
    const newLine = removeLinebreak(fixedData[targetLine]).replace(']', '}')
    fixedData[targetLine] = newLine
  }
  return fixedData
}

const fixCurlyBrackets = ({fixedData, verbose, targetLine}) => {
  if (verbose) psw(chalk.magenta('Curly brackets instead of square ones'))
  const brokenLine = removeLinebreak(
    fixedData[targetLine].includes('{')
      ? fixedData[targetLine]
      : fixedData[++targetLine],
  )
  const fixedLine = replaceChar(brokenLine, brokenLine.indexOf('{'), '[')
  fixedData[targetLine] = fixedLine

  try {
    parse(fixedData.join('\n'))
  } catch (e) {
    targetLine = e.location.start.line - 1
    const newLine = removeLinebreak(fixedData[targetLine]).replace('}', ']')
    fixedData[targetLine] = newLine
  }

  return fixedData
}

const fixComment = ({start, fixedData, verbose}) => {
  if (verbose) psw(chalk.magenta('Comment'))
  const targetLine = start.line - 1
  const brokenLine = removeLinebreak(fixedData[targetLine])
  const fixedLine = brokenLine.replace(/(\s*)(\/\/.*|\/\*+.*?\*+\/)/g, '')
  if (fixedLine.includes('/*')) {
    //Multi-line comment
    let end = targetLine + 1
    while (end <= fixedData.length && !fixedData[end].includes('*/')) ++end
    for (let i = targetLine + 1; i <= end; ++i) fixedData[i] = '#RM'
    fixedData[targetLine] = fixedData[targetLine].replace(/\s*\/\*+.*/g, '#RM')
    return fixedData.filter(l => l !== '#RM')
  }
  fixedData[targetLine] = fixedLine
  return fixedData
}

const fixOpConcat = ({start, fixedData, verbose}) => {
  if (verbose) psw(chalk.magenta('Operations/Concatenations'))
  psw(
    chalk.yellow(
      'Please note: calculations made here may not be entirely correct on complex operations',
    ),
  )
  const targetLine = start.line - 1
  const brokenLine = removeLinebreak(fixedData[targetLine])
  const fixedLine = brokenLine
    /* eslint-disable no-eval */
    .replace(
      /(\d+)\s*([+\-*/%&|^><]|\*\*|>{2,3}|<<|[=!><]=|[=!]==)\s*(\d+)\s*([+\-*/%&|^><]|\*\*|>{2,3}|<<|[=!><]=|[=!]==)*\s*(\d+)*/g,
      eq => eval(eq),
    )
    .replace(/[~!+-]\(?(\d+)\)?/g, eq => eval(eq))
    .replace(/(":\s*)"(.*?)"\s*\+\s*"(.*?)"/g, '$1"$2$3"')
  /* eslint-enable no-eval */
  fixedData[targetLine] = fixedLine
  return fixedData
}

module.exports = {
  fixExtraChar,
  fixSingleQuotes,
  fixTrailingChar,
  fixMissingQuotes,
  fixSquareBrackets,
  fixCurlyBrackets,
  fixComment,
  fixOpConcat,
}
