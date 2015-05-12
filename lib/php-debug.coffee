PhpDebugView = require './php-debug-view'
XdebugClient = require './xdebug-client'

{CompositeDisposable} = require 'atom'

module.exports = PhpDebug =
  phpDebugView: null
  panel: null
  subscriptions: null

  activate: (state) ->
    @phpDebugView = new PhpDebugView(state.phpDebugViewState)
    @panel = atom.workspace.addBottomPanel(item: @phpDebugView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:run': => @run()

  deactivate: ->
    @panel.destroy()
    @subscriptions.dispose()
    @phpDebugView.destroy()
    @xdebugClient.destroy()

  serialize: ->
    phpDebugViewState: @phpDebugView.serialize()

  toggle: ->

    if @panel.isVisible()
      @panel.hide()
      @xdebugClient.stop()

    else
      @panel.show()
      file = atom.project.getPaths()[0] + "\\settings.json"
      console.log(file)
      fs.readFile file, (err, data) =>
        if err
          err
        else
          settings = JSON.parse data
        @xdebugClient = new XdebugClient(settings)
        @xdebugClient.start()
  run:->
    @xdebugClient.sendCommand("run")

  stepInto:->
    @xdebugClient.sendCommand("step_into")
