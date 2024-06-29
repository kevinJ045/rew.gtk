{ getWidgets } = imp './src/widgets/widgets.coffee'
{ getRoot } = imp './src/widgets/root.coffee'

gi = require 'node-gtk'

appOptions = struct
  package: app?.package || ''
  name: ''

  gtk: '4.0'

class App
  constructor: (config = {}) ->
    @config = appOptions config
    @GLib = gi.require 'GLib', '2.0'
    @Gtk = gi.require 'Gtk', config.gtk

    @gtk_app = new @Gtk.Application(config.package, 0)

    gi.startLoop()
    @appLoop = @GLib.MainLoop.new(null, false)

    @archive = {}
    @

  register: (name, handler) ->
    if @archive isnt null
      @archive.register name, handler
 
  setup: (cb) ->
    @gtk_app.on 'activate', () =>
      { Context, widgets, archive } = getWidgets @Gtk, @gtk_app, @appLoop, @config, @archive
      @archive = archive
      Root = getRoot Context, archive, widgets, @Gtk
      cb Root
      @appLoop.run()

  run: () ->
    @status = @gtk_app.run([])

exports { App }