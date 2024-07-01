import { appOptions } from "./config.coffee"
gi = require 'node-gtk'

export class UiContext
  constructor: (config = {}) ->
    @config = appOptions config
    @GLib = gi.require 'GLib', config.glib
    @Gtk = gi.require 'Gtk', config.gtk
    if @config.gio
      @Gio = gi.require 'Gio', if config.gio isnt true then config.gio
    gi.startLoop()

    @Gtk.init()

    @Gtk.selected = config.gtk
    @GLib.selected = config.glib

    if config.gtk is '4.0'
      @appLoop = @GLib.MainLoop.new(null, false)
    @gtk_app = new @Gtk.Application(config.package, 0)

    @require = (name, version) => gi.require(name, version)
    @startMain = () =>
      if @config.gtk is '3.0'
        @Gtk.main()
      else
        @status = @gtk_app.run([])
    @
