import { getUtils } from "./utils.coffee"

export getControlWidgets = (createClass, widgets, Gtk) ->

  utils = getUtils Gtk

  widgets.button = createClass Gtk.Button,
    options: (options) -> { label: options.text || 'Button' }
    name: 'button'
    take: (W) ->
      W::_eventNameAliases = click: 'clicked'
      W::onClick = (handler) ->
        @on 'clicked', handler
    create: (W) ->
      (text, options) -> { text, ...options }

  widgets.toggleButton = createClass Gtk.ToggleButton,
    options: utils.switchOptionsByLabels 'label'
    bindOptions: ['bind']
    name: 'toggleButton'
    onInit: utils.initFn_FromOption 'bind'
    take: (W) ->
      W::_eventNameAliases = toggle: 'toggled'
      utils.boundableWidget W, 'toggled',
        set: (val) -> @widget.setActive val
        get: () -> @widget.getActive()
      
  widgets.check = createClass Gtk.CheckButton,
    inherits: widgets.toggleButton
    name: 'check'

  widgets.radioGroup = createClass Gtk.Box,
    inherits: widgets.box
    name: 'radio-group',
    onInit: ->
      @radio = null
      @group = []
    take: (W) ->
      W::_add = (child) ->
        widgets.box::_add.call @, child
        if child instanceof widgets.radio
          name = child.wrappedByClass?.options?.name or @widget_children
          unless @radio
            @radio = name
          if @group.length
            child.setGroup @group[0]
          @group.push child
          child.on 'toggled', () =>
            if child.getActive()
              @setActive name
      W::setActive = (name) ->
        if @radio is name then return
        @radio = name
        @emit 'change:radio', name

  print Gtk.RadioButton

  widgets.radio = createClass Gtk.RadioButton,
    options: (options) -> { label: options.label || 'Radio Button' }
    name: 'radio'

  widgets.switch = createClass Gtk.Switch,
    onInit: utils.initFn_FromOption 'bind'
    name: 'switch'
    bindOptions: ['bind']
    take: (W) ->
      W::_eventNameAliases = toggle: 'state-set'
      utils.boundableWidget W, 'state-set',
        set: (val) -> @widget.setActive val
        returns: true
        get: () -> @widget.getActive()

  widgets.spinButton = createClass Gtk.SpinButton,
    options: (options) -> options
    name: 'spinButton'

  widgets.comboBox = createClass Gtk.ComboBox,
    name: 'comboBox'

  widgets.comboBoxText = createClass Gtk.ComboBoxText,
    name: 'comboBoxText'

  widgets.entry = createClass Gtk.Entry,
    name: 'entry'

  widgets.searchEntry = createClass Gtk.SearchEntry,
    name: 'searchEntry'

  widgets.passwordEntry = createClass Gtk.PasswordEntry,
    name: 'passwordEntry'

  widgets.entryBuffer = createClass Gtk.EntryBuffer,
    name: 'entryBuffer'
    