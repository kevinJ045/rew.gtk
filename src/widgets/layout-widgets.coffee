import { createGObjectForJObject } from "../modules/utils.coffee"
import { WidgetState } from "../modules/state.coffee"

getLayoutWidgets = (createClass, widgets, Gtk, Gio, GObject) ->
  widgets.headerBar = createClass Gtk.HeaderBar,
    name: 'header-bar'
    take: (W) ->
      W::$_children_count = 0
      W::_centerWidget = (child) ->
        if Gtk.selected is '4.0'
          @widget.setTitleWidget child
        else
          @widget.add child
      # override
      W::_add = (child) ->
        if @$_children_count == 0
          @$_children_count++
          @widget.packStart child
        else if @$_children_count == 1
          @$_children_count++
          @_centerWidget child
        else
          @widget.packEnd child

  widgets.actionBar = createClass Gtk.ActionBar,
    name: 'action-bar'
    inherits: widgets.headerBar
    take: (W) ->
      # override
      W::_centerWidget = (child) ->
        @widget.setCenterWidget child

  widgets.toolbar = createClass Gtk.Toolbar,
    name: 'toolbar'

  widgets.toolbar = createClass Gtk.ListView,
    name: 'list'
    exclude: ['items', 'model', 'forEach']
    # options: (options) -> Object.without(options)
    onInit: (_, options) ->
      if not Gio or not GObject then throw new ReferenceError('You should enable gio(gio: true) and gobject(gobject: true) in config to use the List element');
      @items = new Gio.ListStore()
      @selection = new Gtk.SingleSelection model: @items
      @model = null
      @factory = new Gtk.SignalListItemFactory
      @widget.setModel(@selection)
      @widget.setFactory(@factory)
      for i in @_excludeOptions
        if i of options
          @setProp i, options[i]
      @
    take: (W) ->
      W::onProp 'forEach', (forEachItem) ->
        _getItem = (listItem) =>
          unless listItem.getItem() then return
          elt = forEachItem(listItem.getItem())
          widget = if elt instanceof Gtk.Widget then elt else if createClass.isWidget elt then elt.widget else throw new TypeError('Not a widget')
          if widget
            listItem.setChild widget
        @factory.connect 'setup', (listItem) =>
          _getItem(listItem)
        @factory.connect 'bind', (listItem) =>
          _getItem(listItem)
      W::onProp 'model', (model) ->
        @model = createGObjectForJObject GObject, model
      W::onProp 'items', (items) ->
        _set = (item) =>
          if typeof item.then is "function"
            item.then(_set)
          else
            while @items.getNItems() > 0 then @items.remove(0);
            item.forEach (item, index) =>
              unless @model
                @setProp 'model', item
              item = new @model(item)
              item._index = index
              @items.append(item)
        if createClass.isState(items)
          _set(items.get());
          items.trigger.on 'set', (value) => _set(value)
        else
          _set(items)

  widgets.toolButton = createClass Gtk.ToolButton,
    name: 'toolButton'

  widgets.menuBar = createClass Gtk.MenuBar,
    name: 'menuBar'

  widgets.menu = createClass Gtk.Menu,
    name: 'menu'

  widgets.menuItem = createClass Gtk.MenuItem,
    options: (options) -> { label: options.label || 'Menu Item' }
    name: 'menuItem'
    onInit: (widget, options) ->
      widget.on('activate', => @emit('activate'))

  widgets.popoverMenu = createClass Gtk.PopoverMenu,
    name: 'popoverMenu'


exports { getLayoutWidgets }
