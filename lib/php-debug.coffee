PhpDebugView = require './php-debug-view'
XdebugClient = require './xdebug-client'

{CompositeDisposable} = require 'atom'

module.exports = PhpDebug =
  phpDebugView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @phpDebugView = new PhpDebugView(state.phpDebugViewState)
    @modalPanel = atom.workspace.addBottomPanel(item: @phpDebugView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:run': => @run()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @phpDebugView.destroy()

  serialize: ->
    phpDebugViewState: @phpDebugView.serialize()

  toggle: ->

    if @modalPanel.isVisible()
      @modalPanel.hide()
      @xdebugClient.stop()
    else
      @modalPanel.show()
      @xdebugClient = new XdebugClient(9000)
      @xdebugClient.start()

  run:->
    @xdebugClient.sendCommand("run")
