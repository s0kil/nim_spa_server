#[
  This Module
  Compiles Nim Into JavaScript
  At Compile Time Inside A Nim Application
]#

import os, macros
# import osproc
# import tempfile


type JSCompilerError = object of Exception

# Write To Temporary File, And Return File Name
#[
proc tmpFile(data: string): string =
  var (file, name) = mkstemp(suffix = ".nim", mode = fmWrite)
  defer: file.close()
  write(file, data)
  return name
]#

proc tmpFile(data: string): string =
  const nimFileName = "/tmp/emmitJS.nim"
  echo staticExec("touch " & nimFileName)
  echo staticExec("echo '" & data & "' >" & nimFileName)
  return nimFileName

proc compileToJavaScript(jsFile: string): string =
  var command = "nim js "
  when defined release: command = command & " -d:release "
  let (nimOutput, errCode) = gorgeEx(command & jsFile)
  echo "Hint: JavaScript Emitter\n"
  echo nimOutput
  if errCode != 0: raise newException(JSCompilerError, "Failed To Compile Nim Into JavaScript")
  echo "\nHint: JavaScript Emitter Completed"

proc emitJavaScript(jsInstructions: string): string =
  let nimFileName = tmpFile(jsInstructions)
  echo compileToJavaScript(nimFileName)
  let jsFile = splitFile(nimFileName)
  let jsFilePath = joinPath(jsFile.dir, jsFile.name & ".js")
  return staticRead(jsFilePath)

macro emitJS*(x: untyped): untyped =
  let nimToJS = emitJavaScript(repr(x.body))
  let stmtList = newStmtList()
  stmtList.add newAssignment(newIdentNode("result"), newStrLitNode(nimToJS))
  x.body = stmtList
  # echo x.treeRepr
  result = x

when isMainModule:
  proc jsOutput(): string {.emitJS.} =
    echo "Hello From Nim"
  echo jsOutput()
