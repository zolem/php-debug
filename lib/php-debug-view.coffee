module.exports =
class PhpDebugView
  constructor: () ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('php-debug')
    # Create title element
    header = document.createElement('div')
    header.classList.add('panel-heading')
    title = document.createElement('span')
    title.textContent = "PHP Debugger"
    header.appendChild(title)

    body = document.createElement('div')
    body.classList.add('panel-body')
    body.classList.add('padded')
    content = document.createElement('span')
    content.textContent = "Hello World"
    body.appendChild(content)

    @element.appendChild(header)
    @element.appendChild(body)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
