export getControlWidgets = (createClass, widgets, Gtk) ->
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
    options: (options) -> { label: options.label || 'Toggle Button' }
    name: 'toggleButton'

  widgets.checkButton = createClass Gtk.CheckButton,
    options: (options) -> { label: options.label || 'Check Button' }
    name: 'checkButton'

  widgets.radioButton = createClass Gtk.RadioButton,
    options: (options) -> { label: options.label || 'Radio Button' }
    name: 'radioButton'

  widgets.switch = createClass Gtk.Switch,
    options: (options) -> { active: options.active or false }
    name: 'switch'

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
    