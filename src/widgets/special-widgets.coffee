getSpecialWidgets = (createClass, widgets, Gtk) ->
  widgets.picture = createClass Gtk.Picture,
    options: (options) -> { file: options.file || '' }
    name: 'picture'

  widgets.mediaControls = createClass Gtk.MediaControls,
    name: 'mediaControls'

  widgets.video = createClass Gtk.Video,
    name: 'video'

  widgets.assistant = createClass Gtk.Assistant,
    name: 'assistant'

  widgets.appChooserDialog = createClass Gtk.AppChooserDialog,
    name: 'appChooserDialog'

exports { getSpecialWidgets }
