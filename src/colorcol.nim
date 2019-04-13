import regex, os, strutils

const
  kakSource = slurp "colorcol.kak"
  regexHex = re"\b#?(?:([[:xdigit:]]{6})(?:[[:xdigit:]]{2})?|([[:xdigit:]]{3})(?:[[:xdigit:]])?)\b"

template addColor(color, marker: string) =
  stdout.write "{rgb:", color, "}", marker

func doubleColor(c: string): string {.noinit, inline.} =
  result = newString(6)
  result[0] = c[0]
  result[1] = c[0]
  result[2] = c[1]
  result[3] = c[1]
  result[4] = c[2]
  result[5] = c[2]

if paramCount() == 0:
  stdout.write kakSource
  quit 0

let
  timestamp = paramStr 1
  buffile = paramStr 2
  marker = paramStr 3
  maxMarks = parseInt paramStr 4

var
  n = 0
  matches = 0
  lineMarked = false

stdout.write "set-option buffer colorcol_marks ", timestamp

if existsFile buffile:
  for line in buffile.lines:
    inc n
    matches = 0
    lineMarked = false
    for match in line.findAll(regexHex):
      if not lineMarked:
        stdout.write " ", n, "|"
        lineMarked = true
      for slice in match.group(0):
        addColor line[slice], marker
      for slice in match.group(1):
        addColor line[slice].doubleColor, marker
      inc matches
      if matches == maxMarks: break
