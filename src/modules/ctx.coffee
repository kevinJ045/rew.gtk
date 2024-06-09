getContext = (archive) -> class Context
  parent = null
  name = ''
  children = []
  constructor: (options, name, parent) -> 
    @name = name || 'root'
    @children = []
    @parent = parent || null
    @options = @_constructOptions options
    @_init()

  _constructOptions: (options) ->
    { options... }

  _init: -> 
    archive.filter @name
    .forEach (item) => @[item.name] = (...args) -> 
      v = item.value(@, ...args)
      @children.push v
      v 

  back: ->
    @parent || this
  

exports { getContext }