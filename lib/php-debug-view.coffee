module.exports =
class PhpDebugView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('php-debug')
    # Create title element
    title = document.createElement('h2')
    title.textContent = "The PhpDebug package is Alive! It's ALIVE!"
    title.classList.add('title')
    @element.appendChild(title)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
