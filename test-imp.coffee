ui = imp './main', gtk: '3.0'

ui.gtk_app.on 'activate', ->
  window = ui.Window::create title: 'MyTitle'

  btn = new ui.Gtk.Button( label: 'Click Me' )
  window.setChild btn

  window.show()
  ui.appLoop.run()

ui.startMain()