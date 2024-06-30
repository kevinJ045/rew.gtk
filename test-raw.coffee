gi = require 'node-gtk'
Gtk = gi.require 'Gtk', '4.0'

gi.startLoop()
Gtk.init null

# Create a new Gtk.ApplicationWindow
win = new Gtk.ApplicationWindow()
win.setDefaultSize 200, 100
win.setTitle 'Gtk.SpinButton Example'

# Create a Gtk.Box to contain the spin button
box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 10 })

# Create a Gtk.Adjustment
adjustment = new Gtk.Adjustment({
  lower: 0,     # Minimum value
  upper: 100,   # Maximum value
  value: 50     # Initial value
})

# Create a Gtk.SpinButton
spinButton = new Gtk.SpinButton({ adjustment, digits: 0 })

# Connect a handler to print the value when changed
spinButton.on 'value-changed', ->
  console.log "SpinButton value: #{spinButton.getValue()}"

# Add spin button to the box
box.append spinButton

# Add box to the window
win.setChild(box)

# Handle window closing
win.on 'destroy', -> Gtk.mainQuit()

# Display the window
win.present()

# Start the GTK main loop

