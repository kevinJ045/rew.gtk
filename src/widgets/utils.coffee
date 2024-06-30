
export getUtils = (Gtk) ->
  utils = {}

  utils.switchOrientation = (options) -> { ...options, orientation: if options.orientation is 'horizontal' or options.orientation is 'h' then Gtk.Orientation.HORIZONTAL else Gtk.Orientation.VERTICAL }

  utils.alignments = {
    'start': Gtk.Align.START
    'end': Gtk.Align.END
    'center': Gtk.Align.CENTER
    'baseline': Gtk.Align.BASELINE
    'fill': Gtk.Align.FILL
  }

  utils.policies = {
    'auto': Gtk.PolicyType.AUTOMATIC,
    'automatic': Gtk.PolicyType.AUTOMATIC,
    'always': Gtk.PolicyType.ALWAYS,
    'never': Gtk.PolicyType.NEVER,
    'external': Gtk.PolicyType.EXTERNAL  # Note: Primarily for other widgets, not standard for scrollbars in ScrolledWindow.
  }

  utils.positions = {
    'left': Gtk.PositionType.LEFT
    'top': Gtk.PositionType.TOP
    'right': Gtk.PositionType.RIGHT
    'bottom': Gtk.PositionType.BOTTOM
  }
  
  utils