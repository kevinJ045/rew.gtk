getLayoutWidgets = (createClass, widgets, Gtk) ->
  widgets.headerBar = createClass Gtk.HeaderBar,
    name: 'headerBar'

  widgets.actionBar = createClass Gtk.ActionBar,
    name: 'actionBar'

  widgets.toolbar = createClass Gtk.Toolbar,
    name: 'toolbar'

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
