/*
 * gtk4.js
 */

const gi = require('node-gtk')
const GLib = gi.require('GLib', '2.0')
const Gtk = gi.require('Gtk', '4.0')

gi.startLoop()

const printHello = () => console.log('Hello')

const loop = GLib.MainLoop.new(null, false)

const app = new Gtk.Application('com.github.romgrk.node-gtk.demo', 0)
app.on('activate', onActivate)
const status = app.run([])

console.log('Finished with status:', status)

function onActivate() {
  const window = new Gtk.ApplicationWindow(app)
  window.setTitle('Window')
  window.setDefaultSize(200, 200)

  const button = Gtk.Button.newWithLabel('Hello World')
  button.on('clicked', printHello)

  window.setChild(button)
  window.show()
  window.present()

  window.on('close-request', () => {
    loop.quit()
    process.exit(0)
  })

  loop.run()
}