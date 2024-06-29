{ getContext } = imp '../modules/ctx.coffee'
{ Archive } = imp '../modules/archive.coffee'
{ getContainerWidgets } = imp './container-widgets.coffee'
{ getControlWidgets } = imp './control-widgets.coffee'
{ getDisplayWidgets } = imp './display-widgets.coffee'
{ getSelectionWidgets } = imp './selection-widgets.coffee'
{ getLayoutWidgets } = imp './layout-widgets.coffee'
{ getMiscellaneousWidgets } = imp './miscellaneous-widgets.coffee'
{ getSpecialWidgets } = imp './special-widgets.coffee'
{ getGestureWidgets } = imp './gesture-widgets.coffee'

getWidgets = (Gtk, app, apploop, config = {}, ...archiveStuff) ->

  archive = new Archive archiveStuff
  Context = getContext(archive)
  widgets = {}

  createClass = (GtkClass, { options = ((o) -> o), create, inherits, onInit, name = '', take = (W) -> W } = {}) =>
    if typeof inherits is "function"
      originalOptions = options
      options = (o) ->
        originalOptions inherits::_optionsCreate(o)
      create = () -> inherits::create

    class WidgetClass extends widgets.base
      constructor: (options, parent) ->
        super options, parent, WidgetClass::name
      
      init: ->
        @widget = new GtkClass options @options
        onInit.call(@, @widget, @options) if typeof onInit is "function"

    WidgetClass::name = name if name isnt null
    WidgetClass::_optionsCreate = options

    take WidgetClass

    if not create and not WidgetClass::create
      WidgetClass::create = (options) -> options
    else if typeof create is "function"
      WidgetClass::create = create WidgetClass

    WidgetClass

  widgets.base = class GtkWidget extends Context
    constructor: (options, parent, name = 'widget') ->
      super options, name, parent
      @widget = null
      @init options
      if parent and parent.widget and @widget
        parent.add @widget

    init: ->
      @

    on: (event, handler) ->
      @widget.on event, handler

    add: (child) ->
      @widget.add child

    show: ->
      @widget.show()

  widgets.base::extends = createClass

    

  class GtkWindow extends widgets.base
    constructor: (options, parent) ->
      super options, parent, 'window'
    
    init: (options) ->
      @widget = if config.gtk is '4.0' then new Gtk.ApplicationWindow(app) else new Gtk.Window()
      @widget.setTitle(@options.title || 'Window')
      @widget.setDefaultSize(@options.width || 200, @options.height || 200)

      if options.closeOnQuit isnt false
        @widget.on('close-request',
            ->
              apploop.quit()
              process.exit(0)
          )

    add: (child) ->
      @widget.setChild child

    show: () ->
      @widget.show()
      @widget.present()
      @

  archive.register 'root.window', (root, options) -> new GtkWindow options, root
  
  getContainerWidgets(createClass, widgets, Gtk, app, apploop, config, Gtk)
  getControlWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)
  getDisplayWidgets(createClass, widgets, Gtk, app, apploop, config, Gtk)
  getSelectionWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)
  getLayoutWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)
  getMiscellaneousWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)
  getSpecialWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)
  getGestureWidgets(Context, createClass, widgets, archive, app, apploop, config, Gtk)

  ```
    for(let key in widgets){
      const value = widgets[key];
      archive.register("any."+key, (root, ...args) => {
        options = value.prototype.create(...args)
        return new value(options, root);
      });
    }
  ```

  { Context, widgets, archive }

exports { getWidgets }