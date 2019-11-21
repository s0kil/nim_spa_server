import asyncdispatch, asynchttpserver
import ws

from client import clientSocket
import templates

proc handleWebSocket(req: Request) {.async.} =
  var ws = await newWebSocket(req)
  try:
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      case packet:
      of "/", "": await ws.send(indexTemplate())
      of "/about", "about": await ws.send(aboutTemplate("From Nim"))
      else: echo "404 Not Found"
  except WebSocketError:
    if ws.readyState == Closed:
      echo "Connection Closed"
    else:
      echo getCurrentExceptionMsg()

proc handler(req: Request) {.async.} =
  case req.url.path
  of "/": await req.respond(Http200,
    htmlDocument(
      body = indexTemplate(),
      script = clientSocket()
    )
  )
  of "/about": await req.respond(Http200,
    htmlDocument(
      body = aboutTemplate("From Nim"),
      script = clientSocket()
    )
  )
  of "/ws": discard handleWebSocket(req)
  else:
    echo req.url.path
    await req.respond(Http404, "404 Not Found")

var server = newAsyncHttpServer()
waitFor server.serve(Port(8000), handler)
