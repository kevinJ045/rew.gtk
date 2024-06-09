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

  
  setup: (cb) ->
    @gtk_app.on 'activate', () => 
      Context = getWidgets @Gtk, @gtk_app, @appLoop, @config
      Root = getRoot Context
      cb Root
      @appLoop.run()

  run: () ->
    @status = @gtk_app.run([])

exports { App }