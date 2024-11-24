import { createElement } from "../modules/element.coffee"
Styleway = imp 'styleway'

export getWClass = (ctx, elements) -> Widget = class
    __props: {}
    constructor: (options, name) ->
      @widget = null
      @target = emitter()
      @name = name
      @init options
      @

    _style: {
      _id: genID(),
      css: "",
      provider: null,
      current: {},
      classes: []
    };
    _initStyles: ->
      try
        provider = new ctx.Gtk.CssProvider();
        screen = ctx.Gdk.Display.getDefault();
        @_style.provider = provider;
        @_updateStyles();
        ctx.Gtk.StyleContext.addProviderForDisplay(screen, provider, ctx.Gtk.STYLE_PROVIDER_PRIORITY_USER);
        @widget.getStyleContext().addClass('wid-' + @_style._id);
        @widget.getStyleContext().addClass(@name) if (@name and typeof @name == 'string' and @name.length > 1)
      std::void
    _updateStyles: ->
      try
        css = Styleway { ".wid-#{@_style._id}": @_style.current or {} }
        @_style.provider.loadFromString(css);
        @_style.css = css;
      std::void


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

    getName: () ->
      @widget.getName()
    

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