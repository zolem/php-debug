net = require 'net'

module.exports =
class XdebugClient
  constructor: (@port = 9000) ->
    @server = net.createServer @processData
    @server.maxConnections = 1
    @socket = @server.socket
    @transId = 1

  start: ->
    @server.listen (@port)
    console.log("listening on port " + @port)

  stop: ->
    @socket.end("FIN")
    @server.close()
    console.log("connection closed")

  processData: (socket) ->
    @socket = socket
    console.log('CONNECTED: ' + socket.remoteAddress + ':' + socket.remotePort)
    socket.on "data", (data) ->
      console.log(data.toString())

  sendCommand: (command) ->
    console.log(@sockets)
    @socket.write(command + " -i " + @transId.toString())
    @transId++
