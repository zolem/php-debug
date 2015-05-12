net = require 'net'
o = require 'opener'
fs = require 'fs'
{parseString} = require 'xml2js'

module.exports =
class XdebugClient
  constructor: (@settings) ->
    @server = net.createServer (socket) =>
        @socket = socket
        console.log("Connected: " + socket.remoteAddress + ':' + socket.remotePort)
        socket.on "data", (data) =>
          @processData(data)
    @server.maxConnections = 1
    @port = if @settings and @settings.port then @settings.port else 9000
    @transId = 1
    console.log("Settings: " + @settings)

  start: ->
    @server.listen (@port)
    console.log("listening on port " + @port)
    if @settings?.url? then o @settings.url + "?XDEBUG_SESSION_START"

  stop: ->
    @socket?.end("stop -i " + @transId + "\0")
    @server?.close()
    console.log("connection closed")

  processData: (data) ->
    res = parseString data.toString().split("\0")[1], (err, result) ->
      console.log result

  sendCommand: (command) ->
    msg = command + " -i " + @transId
    @socket.write(msg, "utf8")
    @socket.write("\0")
    @transId++

  destroy: ->
    @server = null
    @transId = 1
