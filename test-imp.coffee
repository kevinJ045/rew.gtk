ui = imp './main', gtk: '4.0'

start = ->
  window = ui.Window::create title: 'MyTitle'

  btn = new ui.Gtk.Button( label: 'Click Me' )
  window.setChild btn

  window.show()
  ui.appLoop.run()

ui.gtk_app.on 'activate', start

ui.startMain()
