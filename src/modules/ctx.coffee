getContext = (archive) -> class Context
  parent = null
  name = ''
  children = []
  constructor: (options, name, parent) -> 
    @name = name || 'root'
    @children = []
    @parent = parent || null
    @options = @_constructOptions options
    @_onbackHandlers = []
    @_init()

  _constructOptions: (options) ->
    { options... }

  _init: -> 
    archive.filter @name
    .forEach (item) => @[item.name] = (...args) -> 
      v = item.value(@, ...args)
      @children.push v
      v 
  
  
  onBack: (cb) ->
    @_onbackHandlers.push(cb)
  back: ->
    @_onbackHandlers.forEach (cb) => cb(@)
    @parent || this
  
  __set__: (prop, val) ->
    @[prop] = val
  

exports { getContext }