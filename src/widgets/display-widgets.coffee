import { getUtils } from "./utils.coffee"

getDisplayWidgets = (createClass, widgets, Gtk) ->
  utils = getUtils Gtk

  getLM = (options) ->
    usesMarkup = if ['color', 'weight', 'underline'].find((i) => i of options) then true else false
    label = options.text || ''
    if usesMarkup and label.length
      label = """<span #{
      (if options.color then "foreground=\"#{options.color}\"" else '')
      } #{
      (if options.weight then "weight=\"#{options.weight}\"" else '')
      } #{
      (if options.underline then "underline=\"#{options.underline}\"" else '')
      }>""" + label + "</span>"
    return {usesMarkup, label}

  widgets.label = createClass Gtk.Label,
    options: (options) ->
      {label, usesMarkup} = getLM options or {}
      { label, use_markup: options.use_markup or usesMarkup }
    name: 'text'
    exclude: ['color', 'underline', 'weight']
    create: (W) ->
      (text, options) -> { text, ...options }
    take: (W) ->
      # override
      W::_updateText = () ->
        {label, usesMarkup} = getLM @options
        @widget.setProperty('use_markup', usesMarkup)
        @widget.setLabel label

      W::onProp 'color', (c) ->
        @options.color = c
        @_updateText()
      W::onProp 'underline', (c) ->
        @options.underline = c
        @_updateText()
      W::onProp 'weight', (c) ->
        @options.weight = c
        @_updateText()

      W::_text = (text) ->
        @options.text = text
        @_updateText()
        

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

  widgets.fixed = createClass Gtk.Fixed,
    name: 'fixed'
    take: (W) ->
      W::_add = (child) ->
        options = child.options or child.wrappedByClass?.options
        @widget.put child, options?['fixed:x'] || 0, options?['fixed:y'] || 0


exports { getDisplayWidgets }
