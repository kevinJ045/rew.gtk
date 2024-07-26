import { getRegistry } from "../modules/registry.coffee"
import { getWClass } from "../modules/widget.coffee"
import { excludeStuff } from "../modules/utils.coffee"

import { getContainerWidgets } from './container-widgets.coffee'
import { getControlWidgets } from './control-widgets.coffee'
import { getDisplayWidgets } from './display-widgets.coffee'
import { getSelectionWidgets } from './selection-widgets.coffee'
import { getLayoutWidgets } from './layout-widgets.coffee'
import { getMiscellaneousWidgets } from './miscellaneous-widgets.coffee'
import { getSpecialWidgets } from './special-widgets.coffee'
import { getGestureWidgets } from './gesture-widgets.coffee'

export createWidgetClass = (ctx) ->

  elements = {}
  ctx.elements = elements;
  Widget = getWClass ctx, elements

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
        if prop == 'style'
          @_style.current = value
          @_updateStyles()
          return @
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
        if @options.style
          @_style.current = @options.style;
          delete @options.style;
        @widget = new GtkClass options(excludeStuff(@options, exclude), @options)
        @widget.wrappedByClass = @;
        @_initStyles();
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

  ###*
   * @param cfg {{ gtk: new () => {}, constructor?: () => any, name?: string, onCreate: () => void }}
  *####
  Widget::class = (cfg) ->
    if typeof cfg == "function" then cfg = cfg()
    GtkClass = cfg.gtk;
    delete cfg.gtk;
    o = {}
    o.onInit = cfg.constructor;
    delete cfg.constructor;
    if cfg.factorArguments
      o.create = cfg.factorArguments;
      delete cfg.factorArguments;
    
    if cfg.name
      o.name = cfg.name;
      delete cfg.name;
    
    o.take = (W) ->
      cfg.onCreate(W) if cfg.onCreate?
      for key, value of cfg
        W::[key] = value
    return createClass GtkClass, o

  getRegistry ctx, elements

  getContainerWidgets createClass, elements, ctx.Gtk
  getControlWidgets createClass, elements, ctx.Gtk
  getDisplayWidgets createClass, elements, ctx.Gtk
  getSelectionWidgets createClass, elements, ctx.Gtk
  getSpecialWidgets createClass, elements, ctx.Gtk
  getLayoutWidgets createClass, elements, ctx.Gtk
  getMiscellaneousWidgets createClass, elements, ctx.Gtk
  getGestureWidgets createClass, elements, ctx.Gtk

  ctx.createClass = createClass
  Widget
