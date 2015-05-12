PhpDebugView = require './php-debug-view'
net = require 'net'
o = require 'opener'
fs = require 'fs'
{parseString} = require 'xml2js'

module.exports =
class XdebugClient
  constructor: (@settings) ->
    @phpDebugView = new PhpDebugView()
    @panel = atom.workspace.addBottomPanel(item: @phpDebugView.getElement(), visible: false)
    @server = net.createServer (socket) =>
        @socket = socket
        socket.on "data", (data) =>
          @processData data
    @server.maxConnections = 1
    @transId = 1

  start: ->
    @panel.show()
    @server.listen (@settings.port)
    console.log("listening on port " + @settings.port)
    if @settings?.url? then o @settings.url + "?XDEBUG_SESSION_START"

  stop: ->
    @socket?.end("stop -i " + @transId + "\0")
    @server?.close()
    @panel.hide()
    console.log("connection closed")

  processData: (data) ->
    res = parseString data.toString().split("\0")[1], (err, result) =>
      if result.init
        @sendCommand("step_into")
      if result.response
        @processResponse result.response

  sendCommand: (command) ->
    msg = command + " -i " + @transId
    @socket.write(msg, "utf8")
    @socket.write("\0")
    @transId++

  destroy: ->
    @server = null
    @transId = 1

  processResponse: (response) =>
    console.log response
    switch response.$.reason
      when "error", "aborted", "exception"
        @stop()
      when "ok"
        switch response.$.status
          when "stopping"
            @stop()
          when "break"

  goToFileLine: (file, lineno) ->
    console.log file, lineno
