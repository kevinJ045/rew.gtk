import { getUtils } from "./utils.coffee"

getDisplayWidgets = (createClass, widgets, Gtk) ->
  utils = getUtils Gtk
  widgets.label = createClass Gtk.Label,
    options: (options) -> { label: options.text || 'Label' }
    name: 'text'
    create: (W) ->
      (text, options) -> { text, ...options }

  widgets.textView = createClass Gtk.TextView,
    name: 'text-view'

  widgets.image = createClass Gtk.Image,
    options: (options) ->
      if options.icon?
        options.icon_name = options.icon
        delete options.icon
      {
        file: options.file || '',
        ...options
      }
    name: 'image'
    create: (W) ->
      (file, options) -> { file, ...options }

  widgets.progressBar = createClass Gtk.ProgressBar,
    name: 'progress-bar'
    take: (W) ->
      # override
      W::_text = (text) -> @widget.setText text

  widgets.levelBar = createClass Gtk.LevelBar,
    name: 'level-bar'

  widgets.statusBar = createClass Gtk.StatusBar,
    name: 'status-bar'

  widgets.infoBar = createClass Gtk.InfoBar,
    name: 'infoBar'

  widgets.messageDialog = createClass Gtk.MessageDialog,
    name: 'messageDialog'

  widgets.toolPalette = createClass Gtk.ToolPalette,
    name: 'toolPalette'


exports { getDisplayWidgets }
