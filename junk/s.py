import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

# Define a callback function to be called when the button is clicked
def on_button_clicked(button):
    print("Button clicked!")

# Create a Gtk.Window
window = Gtk.Window(title="Hello, PyGTK!")
window.connect("destroy", Gtk.main_quit)

# Create a button
button = Gtk.Button(label="Click me")
button.connect("clicked", on_button_clicked)

# Add the button to the window
window.add(button)

# Set window size and show all widgets
window.set_default_size(200, 100)
window.show_all()

# Start the GTK main loop
Gtk.main()
