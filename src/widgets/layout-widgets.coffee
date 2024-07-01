getLayoutWidgets = (createClass, widgets, Gtk) ->
  widgets.headerBar = createClass Gtk.HeaderBar,
    name: 'header-bar'
    take: (W) ->
      # override
      W::$_children_count = 0
      W::_centerWidget = (child) ->
        if Gtk.selected is '4.0'
          @widget.setTitleWidget child
        else
          @widget.add child
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
