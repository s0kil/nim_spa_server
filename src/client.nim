import emitjs
# from emitjs import emitJS

proc clientSocket*(): string {.emitJS.} =
  import dom
  import jswebsockets

  var socket = newWebSocket("ws://localhost:8000/ws")

  socket.onOpen = proc (e: Event) =
    socket.send("Hello From JS")
  socket.onMessage = proc (e: MessageEvent) =
    document.write(e.data)
  socket.onClose = proc (e: CloseEvent) =
    echo e.reason
