getDisplayWidgets = ( createClass, widgets, Gtk) ->
  widgets.text = createClass Gtk.Label,
    options: (options) -> { label: options.text || 'Label' }
    name: 'label'
    create: (W) ->
      (text, options) -> { text, ...options }

  widgets.textView = createClass Gtk.TextView,
    name: 'textView'

  widgets.image = createClass Gtk.Image,
    options: (options) -> { file: options.file || '' }
    name: 'image'
    create: (W) ->
      (file, options) -> { file, ...options }

  widgets.progressBar = createClass Gtk.ProgressBar,
    name: 'progressBar'

  widgets.levelBar = createClass Gtk.LevelBar,
    name: 'levelBar'

  widgets.statusBar = createClass Gtk.StatusBar,
    name: 'statusBar'

  widgets.infoBar = createClass Gtk.InfoBar,
    name: 'infoBar'

  widgets.messageDialog = createClass Gtk.MessageDialog,
    name: 'messageDialog'

  widgets.toolPalette = createClass Gtk.ToolPalette,
    name: 'toolPalette'


exports { getDisplayWidgets }
