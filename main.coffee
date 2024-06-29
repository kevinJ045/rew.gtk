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

class UiContext
  constructor: (config = {}) ->
    @config = appOptions config
    @GLib = gi.require 'GLib', '2.0'
    @Gtk = gi.require 'Gtk', config.gtk
    gi.startLoop()

    @appLoop = @GLib.MainLoop.new(null, false)
    @gtk_app = new @Gtk.Application(config.package, 0)
    @

  startMain: () ->
    @status = @gtk_app.run([])

useChild = (elt, child) ->
  if child instanceof WidgetState
    child.target.on 'set', (newVal) ->
      elt.remove child
      child = newVal
      elt.add newVal
    child = child.get()
  elt.add child

class Fragment
  constructor: (children) ->
    @children = children

createElement = (ctx, elements, element, props, ...children) ->
  if typeof element is "symbol" and props.isFragment
    return Fragment

  if element == Fragment
    return new Fragment(children)

  children = children.flatMap (child) ->
    if child instanceof Fragment
      child.children
    else
      child

  if element of elements
    elt = new (elements[element])(props || {})
    for child in children
      useChild elt, child
    
    for key, value of props
      if key.startsWith 'on'
        eventName = key.slice(2).toLowerCase()
        if eventName then elt.on eventName, value 

    return elt
  else if typeof element == "function"
    return element(props, ...children)
    


class WidgetState
  _value: null
  target: {}
  constructor: (value) ->
    @_value = value
    @target = emitter()
    @

  get: () ->
    return this._value;

  set: (value) ->
    this._value = value
    @target.emit('set', value)
  
createWidgetClass = (ctx) ->

  elements = {}
  ctx.elements = elements;
  class Widget
    constructor: (options, parent, name = 'widget') ->
      @widget = null
      @target = emitter()
      @name = name
      @init options
      if parent and parent.widget and @widget
        parent.add @widget

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
      @widget.add child.widget
    _text: (text) ->
      @widget.setLabel text

    add: (child) ->
      if typeof child == "string" || typeof child == "number"
        @_text child
      else if child instanceof ctx.Gtk.Widget
        @_add child
      else if child instanceof Widget
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

  createClass = (GtkClass, { options = ((o) -> o), create, inherits, onInit, name = '', take = (W) -> W } = {}) ->
    if typeof inherits is "function"
      originalOptions = options
      options = (o) ->
        originalOptions inherits::_optionsCreate(o)
      create = () -> inherits::create

    class WidgetClass extends Widget
      constructor: (options, parent) ->
        super options, parent, WidgetClass::name
      
      init: ->
        @widget = new GtkClass options (@options or {})
        @widget.wrappedByClass = @;
        onInit.call(@, @widget, @options) if typeof onInit is "function"

    WidgetClass::name = name if name isnt null
    WidgetClass::_optionsCreate = options

    take WidgetClass

    if not create and not WidgetClass::create
      WidgetClass::create = (options) -> options
    else if typeof create is "function"
      WidgetClass::create = create WidgetClass

    elements[WidgetClass::name] = WidgetClass if name isnt null
    WidgetClass

  getContainerWidgets createClass, elements, ctx.Gtk
  getControlWidgets createClass, elements, ctx.Gtk
  getDisplayWidgets createClass, elements, ctx.Gtk
  getSelectionWidgets createClass, elements, ctx.Gtk
  getSelectionWidgets createClass, elements, ctx.Gtk
  getLayoutWidgets createClass, elements, ctx.Gtk
  getMiscellaneousWidgets createClass, elements, ctx.Gtk
  getGestureWidgets createClass, elements, ctx.Gtk
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
      window.on 'destroy', ->
        ctx.Gtk.mainQuit()
        ctx.appLoop.quit()
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
    windowContext.show();
    windowContext.window.present() if ctx.config.gtk is '4.0'

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
  ctx.Window.prototype = {}
  ctx.Window::create = (options) -> createWindow ctx, options
  
  ctx.setup = (cb) ->
    ctx.isNameSpace = false
    ctx.gtk_app.on 'activate', ->
      if ctx.isNameSpace
        using namespace ctx, cb
      else
        cb ctx
      ctx.appLoop.run()
    return namespace.group [Usage::create('null', () -> ctx.startMain()), ->], {
      'onUse': ->
        ctx.isNameSpace = true
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