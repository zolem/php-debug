PhpDebugView = require './php-debug-view'
{CompositeDisposable} = require 'atom'

module.exports = PhpDebug =
  phpDebugView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @phpDebugView = new PhpDebugView(state.phpDebugViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @phpDebugView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-debug:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @phpDebugView.destroy()

  serialize: ->
    phpDebugViewState: @phpDebugView.serialize()

  toggle: ->
    console.log 'PhpDebug was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
