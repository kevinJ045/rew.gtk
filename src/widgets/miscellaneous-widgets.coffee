getMiscellaneousWidgets = (Context, createClass, widgets, archive, app, apploop, config, Gtk) ->
  widgets.popoverMenuBar = createClass Gtk.PopoverMenuBar, 
    name: 'popoverMenuBar'

  widgets.aspectFrame = createClass Gtk.AspectFrame, 
    name: 'aspectFrame'

  widgets.frame = createClass Gtk.Frame, 
    options: (options) -> { label: options.label || '' }
    name: 'frame'
    take: (W) ->
      W::add = (child) -> @widget.setChild child

  widgets.separator = createClass Gtk.Separator, 
    options: (options) -> { orientation: options.orientation || Gtk.Orientation.HORIZONTAL }
    name: 'separator'

  widgets.levelBar = createClass Gtk.LevelBar, 
    name: 'levelBar'

  widgets.drawingArea = createClass Gtk.DrawingArea, 
    name: 'drawingArea'

  widgets.revealer = createClass Gtk.Revealer, 
    name: 'revealer'

  widgets.shortcutsWindow = createClass Gtk.ShortcutsWindow, 
    name: 'shortcutsWindow'

  widgets.fileChooserButton = createClass Gtk.FileChooserButton, 
    name: 'fileChooserButton'

  widgets.expander = createClass Gtk.Expander, 
    options: (options) -> { label: options.label || '' }
    name: 'expander'

  widgets.progressIndicator = createClass Gtk.ProgressIndicator, 
    name: 'progressIndicator'

  widgets.listView = createClass Gtk.ListView, 
    name: 'listView'

  widgets.columnView = createClass Gtk.ColumnView, 
    name: 'columnView'

  widgets.treeView = createClass Gtk.TreeView, 
    name: 'treeView'
    onInit: (widget, options) -> 
      if options.model
        widget.setModel(options.model)
      if options.columns
        for col in options.columns
          column = new Gtk.TreeViewColumn({ title: col.title })
          renderer = new Gtk.CellRendererText()
          column.packStart(renderer, true)
          column.addAttribute(renderer, 'text', col.index)
          widget.appendColumn(column)

exports { getMiscellaneousWidgets }
