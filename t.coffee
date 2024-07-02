using namespace imp('./main', gtk: '4.0').setup ->
	using Window, ->
		@setChild new Gtk.Button( label: 'Click Me' )
