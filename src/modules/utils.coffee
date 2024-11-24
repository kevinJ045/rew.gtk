defaultExcludes = [
  'class'
  'className'
  'useBy'
  'useRef'
  'bind'
  'window_prop'
]

export excludeStuff = (options, exclude) ->
  o = {...options}
  excludes = [...defaultExcludes, ...exclude]
  for i in excludes
    delete o[i]
  o

export createGObjectForJObject = (GObject, jsObject) ->
  class CustomGObject extends GObject.Object
    constructor: (properties) ->
      super()
      for key of properties
        @[key] = properties[key]
      @
  return CustomGObject