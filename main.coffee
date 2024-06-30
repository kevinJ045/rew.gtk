{ getContainerWidgets } = imp './src/widgets/container-widgets.coffee'
{ getControlWidgets } = imp './src/widgets/control-widgets.coffee'
{ getDisplayWidgets } = imp './src/widgets/display-widgets.coffee'
{ getSelectionWidgets } = imp './src/widgets/selection-widgets.coffee'
{ getLayoutWidgets } = imp './src/widgets/layout-widgets.coffee'
{ getMiscellaneousWidgets } = imp './src/widgets/miscellaneous-widgets.coffee'
{ getSpecialWidgets } = imp './src/widgets/special-widgets.coffee'
{ getGestureWidgets } = imp './src/widgets/gesture-widgets.coffee'
gi = require 'node-gtk'

appOptions = struct
  package: app?.package || ''
  name: ''

  gtk: '4.0'
  glib: '2.0'

class UiContext
  constructor: (config = {}) ->
    @config = appOptions config
    @GLib = gi.require 'GLib', config.glib
    @Gtk = gi.require 'Gtk', config.gtk
    gi.startLoop()

    @Gtk.init()

    @Gtk.selected = config.gtk
    @GLib.selected = config.glib

    if config.gtk is '4.0'
      @appLoop = @GLib.MainLoop.new(null, false)
    @gtk_app = new @Gtk.Application(config.package, 0)
    @

  require: (name, version) -> gi.require(name, version)

  startMain: () ->
    if @config.gtk is '3.0'
      @Gtk.main()
    else
      @status = @gtk_app.run([])

useChild = (elt, child) ->
  if child instanceof WidgetState
    child.target.on 'set', (newVal) ->
      elt.remove child
      child = newVal
      elt.add newVal
    child = child.get()
  else if child.$_isGhostWidget
    return
  print elt unless elt.add
  elt.add child

class Fragment
  constructor: (children) ->
    @children = children

aspectProps = (props) ->
  Object.fromEntries Object.entries(props).map(([prop, value]) -> [prop, if value instanceof WidgetState then value.get() else value])

createElement = (ctx, elements, element, props = {}, ...children) ->
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

      if key.startsWith 'on'
        eventName = key.slice(2).toLowerCase()
        if elt._eventNameAliases? and eventName of elt._eventNameAliases
          eventName = elt._eventNameAliases[eventName]
        if eventName then elt.on eventName, value 

    return elt
  else if typeof element == "function"
    return element(props || {}, ...children)

defaultExcludes = [
  'name'
  'useBy'
  'useRef'
  'bind'
]
excludeStuff = (options, exclude) ->
  o = {...options}
  excludes = [...defaultExcludes, ...exclude]
  for i in excludes
    delete o[i]
  o


class WidgetState
  _value: null
  target: {}
  constructor: (value) ->
    @_value = value
    @target = emitter()
    @

  get: () ->
    return this._value;

  set: (value, notify = true) ->
    this._value = value
    if notify then @target.emit('set', value)

class WidgetRef extends WidgetState
  set: (value) ->
    super.set value
    @widget = value
  
createWidgetClass = (ctx) ->

  elements = {}
  ctx.elements = elements;
  class Widget
    constructor: (options, name) ->
      @widget = null
      @target = emitter()
      @name = name
      @init options
      @

    init: ->
      @

    on: (event, handler) ->
      @widget.on event, handler
      @target.on event, handler

    emit: (event, data) ->
      @target.emit event, data
    
    off: (event, handler) ->
      @target.off event, handler

    _add: (child) ->
      try
        @widget.add child.widget
      catch
        @widget.append child.widget
      
    _text: (text) ->
      @widget.setLabel text

    setProp: (prop, value) ->
      @widget.setProperty prop, value
    

    widget_children: []
    add: (child) ->
      if typeof child == "string" || typeof child == "number" || typeof child == "boolean"
        @_text child.toString()
      else if child instanceof ctx.Gtk.Widget
        @_add child
      else if child instanceof Widget
        @widget_children.push child
        @_add child.widget

    remove: (child) ->
      if typeof child == "string" || typeof child == "number"
        @_text ''
      else if child instanceof ctx.Gtk.Widget
        @widget.remove child
      else if child instanceof Widget
        @widget.remove child.widget

    show: ->
      @widget.show()

    create: (element, props, ...children) -> createElement(ctx, elements, element, props, ...children)

  createClass = (GtkClass, { options = ((o) -> o), create, exclude = [], bindOptions = [], resolveNamespaceProps = [], inherits, onInit, name = '', take = (W) -> W } = {}) ->
    if typeof inherits is "function"
      originalOptions = options
      options = (o) ->
        originalOptions inherits::_optionsCreate(o)
      create = () -> inherits::create
      exclude = [...exclude, ...inherits::_excludeOptions]
      bindOptions = [...bindOptions, ...inherits::bindOptions]
      resolveNamespaceProps = [...resolveNamespaceProps, ...inherits::__namespaceProps]
      originalTake = take
      take = (W) ->
        inherits::_take W
        originalTake W
      originalOnInit = onInit
      onInit = (...args) ->
        inherits::__initiationCall.call @, args...
        if typeof originalOnInit == 'function'
          originalOnInit.call @, args...

    propSet = []
    onProp = (prop, cb) ->
      propSet.push name: prop, cb: cb

    class WidgetClass extends Widget
      constructor: (options) ->
        super options, WidgetClass::name

      setProp: (prop, value) ->
        if prop in exclude
          propSet
            .filter (p) -> p.name == prop
            .forEach (p) => p.cb.call @, value
          return @
        newOpt = options ({...@options, [prop]: value})
        @widget.setProperty prop, newOpt[prop]
        @

      init: (opts) ->
        @options = {...opts, ...(@options or {})}
        @widget = new GtkClass options(excludeStuff(@options, exclude), @options)
        @widget.wrappedByClass = @;
        onInit.call(@, @widget, @options) if typeof onInit is "function"

    WidgetClass::name = name if name isnt null
    WidgetClass::_optionsCreate = options
    WidgetClass::onProp = onProp
    WidgetClass::bindOptions = bindOptions
    WidgetClass::_excludeOptions = exclude
    WidgetClass::__initiationCall = onInit or (->)
    WidgetClass::__namespaceProps = resolveNamespaceProps
    WidgetClass.GtkClass = GtkClass

    take WidgetClass
    WidgetClass::_take = take

    if not create and not WidgetClass::create
      WidgetClass::create = (options) -> options
    else if typeof create is "function"
      WidgetClass::create = create WidgetClass

    elements[WidgetClass::name] = WidgetClass if name isnt null
    WidgetClass

  getContainerWidgets createClass, elements, ctx.Gtk, WidgetState
  getControlWidgets createClass, elements, ctx.Gtk, WidgetState
  getDisplayWidgets createClass, elements, ctx.Gtk, WidgetState
  getSelectionWidgets createClass, elements, ctx.Gtk, WidgetState
  getSelectionWidgets createClass, elements, ctx.Gtk, WidgetState
  getLayoutWidgets createClass, elements, ctx.Gtk, WidgetState
  getMiscellaneousWidgets createClass, elements, ctx.Gtk, WidgetState
  getGestureWidgets createClass, elements, ctx.Gtk, WidgetState
  Widget

createWindow = (ctx, options) ->
  window = if ctx.config.gtk is '4.0' then new ctx.Gtk.ApplicationWindow(ctx.gtk_app) else new ctx.Gtk.Window()
  window.setTitle if options.title? then options.title else 'Window'

  if options.closeOnQuit isnt false
    if ctx.config.gtk is '4.0'
      window.on 'close-request', ->
        ctx.appLoop.quit()
        process.exit(0)
    else
      window.on('delete-event', () => false)
      window.on 'destroy', ->
        ctx.Gtk.mainQuit()
        process.exit(0)

  _setChild = (child) => if ctx.config.gtk is '4.0' then window.setChild child else window.add child

  windowContext = { window }
  windowContext.setTitle = (title) => window.setTitle title
  windowContext.setChild = (child) ->
    if child instanceof ctx.Widget
      _setChild child.widget
    else
      _setChild child

  windowContext.show = -> if ctx.config.gtk is '4.0' then window.show() else window.showAll()
  windowContext.present = -> window.present()
  windowContext.hide = -> window.hide()
  
  windowContext
    

createUiApp = (options) ->
  ctx = new UiContext options

  ctx.Widget = createWidgetClass(ctx)

  ctx.refine = (cb) ->
    if typeof cb == "function"
      namespace.group [ctx, cb], use: () -> using namespace this
    else
      (cb2) -> Usage::group cb, cb2

  ctx.Window = Usage::create 'ui.window', (options, cb) ->
    if typeof options is "function" and not cb
      cb = options
      options = {}

    windowContext = createWindow ctx, options
    if ctx.config.gtk is '4.0'
      windowContext.show();
      windowContext.window.present() 

    windowContext.$$states = {};
    windowContext.$$renders = 0;
    windowContext.$$stateCount = 0;
    windowContext.state = (value) ->
      id = windowContext.$$stateCount
      windowContext.$$stateCount++
      return windowContext.$$states[id] if windowContext.$$states[id]?
      state = new WidgetState value
      windowContext.$$states[id] = state
      # state.target.on 'set', ->
      #   windowContext.render()
      state
    
    windowContext.ref = () -> new WidgetRef

    windowContext.render = ->
      windowContext.$$renders++
      windowContext.$$stateCount = 0
      currentChild = windowContext.window.getChild()
      if currentChild?
        currentChild.wrappedByClass.emit('destroy') if currentChild.wrappedByClass?
        # windowContext.window.remove currentChild
        # currentChild.destroy()
      widget = cb.call(windowContext)
      windowContext.setChild widget
    
    windowContext.render()
    windowContext.show() if ctx.config.gtk is '3.0'
  ctx.Window.prototype = {}
  ctx.Window::create = (options) -> createWindow ctx, options
  
  ctx.setup = (cb) ->
    ctx.isNameSpace = false
    start = ->
      if ctx.isNameSpace
        using namespace ctx, cb
      else
        cb ctx
      if ctx.config.gtk is '4.0' then ctx.appLoop.run()
    ctx.gtk_app.on 'activate', start
    return namespace.group [Usage::create('null', () -> ctx.startMain()), ->], {
      'onUse': ->
        ctx.isNameSpace = true
        if ctx.config.gtk is '3.0' then start()
        ctx.startMain()
    }
  
  
  return ctx


UI = Usage::create 'gui', (options, cb) ->
  if Array.isArray options
    options = { with: options, gtk: '4.0' }
  if typeof options is "function" and not cb
    cb = options
    options = { gtk: '4.0' }
  cb createUiApp appOptions options

UI.init = (options) -> createUiApp appOptions options

module.exports = if Object.keys(imports.assert).find((i) -> Object.keys(appOptions()).includes(i)) then UI.init(imports.assert) else UI