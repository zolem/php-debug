XdebugClient = require './xdebug-client'
fs = require "fs"

{CompositeDisposable} = require 'atom'

module.exports = PhpDebug =
  subscriptions: null
  settings: null

  activate: (state) ->
    file = atom.project.getPaths()[0] + "\\settings.json"

    @settings =
      if fs.existsSync file
      then JSON.parse fs.readFileSync file
      else {"url":null, "remote":null, "local":null, "port": 9000}

    @xdebugClient = new XdebugClient(@settings)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:run': => @sendCommand("run")
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:stepInto': => @sendCommand("step_into")

  deactivate: ->
    @xdebugClient.panel.destroy()
    @subscriptions.dispose()
    @xdebugClient.destroy()

  toggle: ->

    if @xdebugClient.panel.isVisible()
      @xdebugClient.stop()
    else
      @xdebugClient.start()

  sendCommand: (command) ->
    @xdebugClient.sendCommand(command)
