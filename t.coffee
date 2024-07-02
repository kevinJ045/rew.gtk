using namespace imp('./main', gtk: '4.0').setup ->
	using Window, ->
		print Object.keys @
		@setChild new Gtk.Button( label: 'Click Me' )
