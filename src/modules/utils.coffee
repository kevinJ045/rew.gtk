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