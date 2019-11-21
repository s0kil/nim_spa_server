import asyncdispatch, asynchttpserver
import ws

from client import clientSocket
import templates

proc handleWebSocket(req: Request) {.async.} =
  var ws = await newWebSocket(req)
  try:
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      await ws.send indexTemplate(packet)
  except WebSocketError:
    if ws.readyState == Closed:
      echo "Connection Closed"
    else:
      echo getCurrentExceptionMsg()

proc handler(req: Request) {.async.} =
  if req.url.path == "/ws": discard handleWebSocket(req)
  elif req.url.path == "/":
    await req.respond(Http200, htmlDocument(script = clientSocket()))

var server = newAsyncHttpServer()
waitFor server.serve(Port(8000), handler)
