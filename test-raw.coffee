gi = require('node-gtk')
GLib = gi.require('GLib', '2.0')
Gtk = gi.require('Gtk', '4.0')

gi.startLoop()

mainloop = GLib.MainLoop.new(null, false)
app = new Gtk.Application('com.github.romgrk.node-gtk.demo', 0)

onActivate = () ->
  window = new Gtk.ApplicationWindow(app)
  window.setTitle('Window')
  window.setDefaultSize(200, 200)

  window.on 'close-request', ->
    print 'sss'
    mainloop.quit()
    process.exit(0)
      

  button = Gtk.Button.newWithLabel('Hello World')
  button.on('clicked', () => console.log('Hello'))

  window.setChild(button)
  window.show()
  window.present()

  mainloop.run()

app.on('activate', onActivate)
status = app.run([])
