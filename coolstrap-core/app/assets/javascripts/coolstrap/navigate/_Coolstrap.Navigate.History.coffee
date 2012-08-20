###
* Stores the stack of displayed <sections>
* @namespace COOLSTRAP.Navigate
* @class History
*
* @author Abraham Barrera <abarrerac@gmail.com> || @abraham_barrera
###

COOLSTRAP.Navigate.History = ((cool, document, window) ->
  TARGET = cool.Constants.TARGET
  STACK =
    main: []
    container: {}

  prevent_hash_change = false
  console = cool.Console
  _mainStack = ->
    STACK[TARGET.MAIN]

  _containerStack = (container_id) ->
    STACK[TARGET.CONTAINER][container_id] = []  unless STACK[TARGET.CONTAINER][container_id]
    STACK[TARGET.CONTAINER][container_id]

  _containerStackLevel = (container_id) ->
    if container_id
      STACK[TARGET.CONTAINER][container_id + "_level"] = size: 0  unless STACK[TARGET.CONTAINER][container_id + "_level"]
      STACK[TARGET.CONTAINER][container_id + "_level"]
    else
      size: 1

  _back = ->
    prevent_hash_change = true
    window.history.back()

  _go = (position) ->
    prevent_hash_change = true
    window.history.go position

  setup = ->
    #window.onpopstate = _onPopState
    #window.onhashchange = _onHashChange
  ###
    * Create a new element to the browsing history
    *
    * @method add
    *
    * @param  {string} Id of the section.
  ###
  add = (options) ->
    section_id = options.section_id
    container_id = options.container_id or null
    #replace_state = options.replace_state or false
    stack = (if not container_id then _mainStack() else _containerStack(container_id))
    stack.push section_id
    _containerStackLevel(container_id).size += 1
    #if replace_state
    #  _replaceState section_id, container_id
    #else
    #  _pushState section_id, container_id


  ###
    * Returns the current browsing history section id.
    *
    * @method current
    *
    * @return {string} Current section id.
  ###
  current = (container_id) ->
    stack = (if not container_id then _mainStack() else _containerStack(container_id))
    stack[stack.length - 1]
  ###
    * Removes the current item browsing history.
    *
    * @method removeLast
  ###
  removeLast = (container_id) ->
    stack = (if not container_id then _mainStack() else _containerStack(container_id))
    stack.length -= 1
    _containerStackLevel(container_id).size -= 1
    if container_id and _containerStackLevel(container_id).size is 0
      section_id = current(container_id)
      _replaceState section_id, container_id
      _containerStackLevel(container_id).size = 1
    else
      _back()
  ###
    * Returns lenght of history stack
    * 
    * @method size
  ###
  size = (container_id) ->
    stack = (if not container_id then _mainStack() else _containerStack(container_id))
    stack.length
  
  ###
    * Removes all history on container.
    *
    * @method clear
  ###
  clear = (container_id) ->
    console.info "clear: " + container_id
    #container_id = cool.Util.cleanUrl(container_id)  if container_id
    stack = (if not container_id then _mainStack() else _containerStack(container_id))
    ###
    stack.length -= 1
    if container_id
      if _containerStackLevel(container_id).size <= 0
        _back()
      else
        _go -1 * _containerStackLevel(container_id).size
      _containerStackLevel(container_id).size = 0
    ###
  add: add
  current: current
  removeLast: removeLast
  size: size
  clear: clear
  setup: setup
)(COOLSTRAP, document, window)
