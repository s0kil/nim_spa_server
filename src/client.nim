import emitjs

proc clientSocket*(): string {.emitJS.} =
  import dom
  import jsffi, times

  from karax/kdom_impl import Node, Location, window
  import jswebsockets

  proc debug[T](x: T) {.importc: "console.log", varargs.}

  let host = kdom_impl.window.location.host
  let socketURL = "wss://" & host & "/ws"

  var latency: NanoSecondRange
  let root = document.getElementById("root")
  let footer = document.getElementById("footer")

  # var socket = newWebSocket("ws://localhost:8000/ws")
  var socket = newWebSocket(socketURL)
  socket.onOpen = proc (e: Event) =
    footer.innerHTML = "WebSocket Open"
    # debug(e)
  socket.onClose = proc (e: CloseEvent) = debug(e.reason)
  socket.onMessage =
    proc (e: MessageEvent) =
      let latency = nanosecond(getTime()) - latency;
      footer.innerHTML = "WebSocket Latency: " & $latency & " Nanoseconds";
      root.innerHTML = e.data

  dom.window.addEventListener("click",
    proc(e: Event) =
      e.preventDefault()
      let href = e.target.getAttribute("href");
      if href != nil:
        latency = nanosecond(getTime())
        socket.send(href)
        # TODO : Emplement Router (History & Location)
        # let path = window.location.host & "/" & href
        # window.history.pushState(newJsObject(), href, path);
  )
  dom.window.addEventListener("popstate", proc(e: Event) = debug(dom.window.location))
