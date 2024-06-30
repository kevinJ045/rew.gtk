
export getUtils = (Gtk) ->
  utils = {}

  utils.switchOrientation = (options) -> { ...options, orientation: if options.orientation is 'horizontal' or options.orientation is 'h' then Gtk.Orientation.HORIZONTAL else Gtk.Orientation.VERTICAL }

  utils.switchOptionsByLabels = (...labels) -> (options) ->
    o = {...options}
    for label in labels
      o[label] = if options[label]? then options[label] else ''
    o

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

  utils.boundableWidget = (W, eventKey, { get: getFn, returns, set: setFn }) ->
    isDef = false
    if eventKey.startsWith '-'
      eventKey = eventKey.slice(1)
    W::bind = (value) ->
      (if isDef then @on else @target.on) eventKey, () =>
        if @$_ignoreNext___BINDCHANGE
          @$_ignoreNext___BINDCHANGE = false
          return
        @$_ignoreNext___STATECHANGE = true
        value.set getFn.call(@)
        if returns then return (if typeof returns == "function" then returns() else returns)
        else return null
      value.target.on 'set', (val) =>
        if @$_ignoreNext___STATECHANGE
          @$_ignoreNext___STATECHANGE = false
          return
        @$_ignoreNext___BINDCHANGE = true
        setFn.call @, val
      setFn.call @, value.get()

    W::onProp 'bind', (value) ->
      @bind value

  utils.initFn_FromOption = (opts...) ->
    (_, options) ->
      for opt in opts
        if opt of options
          @[opt] options[opt]
  
  utils.convertOptions = (Roptions) ->
    (options) ->
      o = {...options}
      for key, val of options
        if key of Roptions
          o[key] = Roptions[key](val)
      o
    
  utils