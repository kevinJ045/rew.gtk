getSelectionWidgets = (createClass, widgets, Gtk) ->
  widgets.fileChooser = createClass Gtk.FileChooserDialog,
    name: 'fileChooser'

  widgets.fontChooser = createClass Gtk.FontChooserDialog,
    name: 'fontChooser'

  widgets.colorChooser = createClass Gtk.ColorChooserDialog,
    name: 'colorChooser'

exports { getSelectionWidgets }
