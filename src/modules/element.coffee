import { WidgetState, WidgetRef } from "./state.coffee"


export useChild = (elt, child) ->
  unless child then return
  if child instanceof WidgetState
    child.target.on 'set', (newVal) ->
      elt.remove child
      child = newVal
      elt.add newVal
    child = child.get()
  else if child.$_isGhostWidget
    return
  if child.options?.window_prop?
    elt.__props[child.options.window_prop] = child
    return
  elt.add child

aspectProps = (props) ->
  Object.fromEntries Object.entries(props).filter(([prop]) -> not prop.startsWith 'on:').map(([prop, value]) -> [prop, if value instanceof WidgetState then value.get() else value])

class Fragment
  constructor: (children) ->
    @children = children

export createElement = (ctx, elements, element, props = {}, ...children) ->
  if typeof element is "symbol" and props.isFragment
    return Fragment

  if element == Fragment
    return new Fragment(children)

  children = children.flatMap (child) ->
    if child instanceof Fragment
      child.children
    else
      child

  preparedProps = if props then aspectProps(props) else {}

  if element of elements
    ElementClass = elements[element]
    callElt = {}
    keep = {}

    # print element

    if ElementClass::__namespaceProps? and ElementClass::__namespaceProps.length > 0
      keys = Object.keys(preparedProps)
      for prop in ElementClass::__namespaceProps
        matchingKeys = keys.filter (p) -> p.startsWith "#{prop}:"
        camel = false
        if prop.endsWith '*'
          camel = true
          prop = prop.slice(0, -1)
        
        if matchingKeys.length > 0
          if preparedProps[prop]
            preparedProps[prop] = { _default: preparedProps[prop] }
          else preparedProps[prop] = {}
          
          for key in matchingKeys
            actualKey = key.substring(prop.length + 1)
            actualKey = actualKey.replace(/-./g, (match) -> if camel then match[1].toUpperCase() else '_'+match.slice(1))

            preparedProps[prop][actualKey] = preparedProps[key]
            delete preparedProps[key]

    if ElementClass::bindOptions
      for opt in ElementClass::bindOptions
        keep = false
        if opt.endsWith('*')
          keep = true
          opt = opt.slice(0, -1)
        if opt of (props or {})
          if keep
            preparedProps[opt] = props[opt]
          else
            delete preparedProps[opt]
            callElt[opt] = props[opt]
    
    for key, value of preparedProps
      if key.match('-')
        preparedProps[key.replace(/-(.)/g, '_$1')] = value
        delete preparedProps[key]

    elt = new ElementClass preparedProps

    for child in children
      useChild elt, child

    for key, val of callElt
      elt[key](val)

    for key, value of preparedProps
      if props[key] instanceof WidgetState
        props[key].target.on 'set', (newVal) ->
          elt.setProp key, newVal

      props[key].call(elt, elt) if key == 'useBy' and typeof props[key] == 'string'
      if key == 'useRef' and props[key] instanceof WidgetRef
        props[key].set elt
    
    for key, value of (props or {})
      if key.startsWith 'on:'
        eventName = key.slice(3).toLowerCase()
        if elt._eventNameAliases? and eventName of elt._eventNameAliases
          eventName = elt._eventNameAliases[eventName]
        if eventName then elt.on eventName, value 

    return elt
  else if typeof element == "function"
    return element(props || {}, ...children)
