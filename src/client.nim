import emitjs

proc clientSocket*(): string {.emitJS.} =
  import dom, jsffi, times

  from karax/kdom_impl import Node
  import jswebsockets

  proc debug[T](x: T) {.importc: "console.log", varargs.}

  var latency: NanoSecondRange

  var socket = newWebSocket("ws://localhost:8000/ws") #192.168.254.72
  socket.onOpen = proc (e: Event) = debug(e)
  socket.onClose = proc (e: CloseEvent) = debug(e.reason)
  socket.onMessage =
    proc (e: MessageEvent) =
      let footer = document.getElementById("footer")
      footer.innerHTML = "Latency: " & $(nanosecond(getTime()) - latency) & " Nanoseconds"

      # debug(e.data)
      document.getElementById("root").innerHTML = e.data

  window.addEventListener("click",
    proc(e: Event) =
      e.preventDefault()
      let href = e.target.getAttribute("href");
      if href != nil:
        latency = nanosecond(getTime())
        socket.send(href)
        # TODO : Properly Emplement Router (History & Location)
        # let path = window.location.host & "/" & href
        # window.history.pushState(newJsObject(), href, path);
  )
  window.addEventListener("popstate", proc(e: Event) = debug(window.location))
