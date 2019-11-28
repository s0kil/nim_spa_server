import jester
import ws, ws/jester_extra

from client import clientSocket
import templates

settings:
  port = Port(8000)

routes:
  get "/":
    resp htmlDocument(
      body = indexTemplate(),
      script = clientSocket()
    )
  get "/about":
    resp htmlDocument(
      body = aboutTemplate("From Nim"),
      script = clientSocket()
    )
  get "/ws":
    var ws = await newWebSocket(request)
    try:
      while ws.readyState == Open:
        let packet = await ws.receiveStrPacket()
        case packet:
        # TODO : Proper Routes Path
        of "/", "": await ws.send(indexTemplate())
        of "/about", "about": await ws.send(aboutTemplate("From Nim"))
        else: echo "404 Not Found"
    except WebSocketError:
      if ws.readyState == Closed:
        echo "Connection Closed"
      else:
        echo getCurrentExceptionMsg()
