var gi, Gtk, win, box, radio1, radio2, radio3, radio;
gi = require('node-gtk')
Gtk = gi.require('Gtk', '4.0')

gi.startLoop()
Gtk.init(null)

// Create a new Gtk.ApplicationWindow
win = new Gtk.ApplicationWindow()
win.setDefaultSize(400, 200)
win.setTitle('Gtk.RadioButton Example')

// Create a Gtk.Box to contain the radio buttons
box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL, spacing: 10 })

// Create the first Gtk.RadioButton
radio1 = new Gtk.RadioButton({ label: 'Option 1' })

// Create the second Gtk.RadioButton in the same group as radio1
radio2 = new Gtk.RadioButton({ label: 'Option 2', group: radio1 })

// Create the third Gtk.RadioButton in the same group as radio1
radio3 = new Gtk.RadioButton({ label: 'Option 3', group: radio1 })

// Add a handler to print the selected option when changed
for (let ref = [radio1, radio2, radio3], i = 0, len = ref.length; i < len; i++) {radio = ref[i];
  radio.on('toggled', function() {
    if (radio.getActive()) {
      return console.log(`Selected: ${radio.getLabel()}`)
    };return
  })
}

// Add radio buttons to the box
box.append(radio1)
box.append(radio2)
box.append(radio3)

// Add box to the window
win.setChild(box)

// Handle window closing
win.on('destroy', function() { return Gtk.mainQuit() })

// Display the window
win.present()

// Start the GTK main loop
Gtk.main()

