getContainerWidgets = (createClass, widgets, Gtk) ->

  widgets.box = createClass Gtk.Box,
    options: (options) -> { ...options, orientation: if options.orientation is 'horizontal' or options.orientation is 'h' then Gtk.Orientation.HORIZONTAL else Gtk.Orientation.VERTICAL }
    name: 'box'
    take: (W) ->
      W::_add = (child) -> @widget.append child

  widgets.grid = createClass Gtk.Grid,
    name: 'grid'
    take: (W) ->
      W::attach = (child, left, top, width, height) ->
        @widget.attach(child, left, top, width, height)

  widgets.stack = createClass Gtk.Stack,
    name: 'stack'

  widgets.overlay = createClass Gtk.Overlay,
    name: 'overlay'

  widgets.paned = createClass Gtk.Paned,
    name: 'paned'

  widgets.scrolledWindow = createClass Gtk.ScrolledWindow,
    name: 'scrolledWindow'

  widgets.notebook = createClass Gtk.Notebook,
    name: 'notebook'
    take: (W) ->
      W::addPage = (label, child) ->
        pageLabel = new Gtk.Label({ label })
        @widget.appendPage(child.widget, pageLabel)

  widgets.popover = createClass Gtk.Popover,
    name: 'popover'

  widgets.flowBox = createClass Gtk.FlowBox,
    name: 'flowBox'

  widgets.listBox = createClass Gtk.ListBox,
    name: 'listBox'


exports { getContainerWidgets }
