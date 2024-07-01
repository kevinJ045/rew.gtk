ui = imp './main', gtk: '3.0'

start = ->
  window = ui.Window::create title: 'MyTitle'

  print window

  btn = new ui.Gtk.Button( label: 'Click Me' )
  window.setChild btn

  window.show()
  # ui.appLoop.run()

ui.gtk_app.on 'activate', start

start()
ui.startMain()