import { getUtils } from "./utils.coffee"

export getControlWidgets = (createClass, widgets, Gtk) ->

  utils = getUtils Gtk

  widgets.button = createClass Gtk.Button,
    options: (options) -> { label: options.text || 'Button' }
    name: 'button'
    take: (W) ->
      W::_eventNameAliases = click: 'clicked'
      W::_add = (child) ->
        @widget.setChild child
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
    bindOptions: ['bind*']
    onInit: (_, options) ->
      @radio = if options.bind? then options.bind.get() else null
      @group = []
      if options.bind?
        @bind options.bind
    take: (W) ->
      W::_add = (child) ->
        widgets.box::_add.call @, child
        if child instanceof Gtk.CheckButton
          name = child.wrappedByClass?.options?.name or @widget_children
          if @radio?
            if @radio == name
              child.setActive true
          else
            @radio = name
          if @group.length
            child.setGroup @group[0]
          @group.push child
          child.$_RADIO_NAME = name;
          child.on 'toggled', () =>
            if child.getActive()
              @setActive name
              
      W::setActive = (name) ->
        if @radio is name then return
        @radio = name
        @group.forEach (r) ->
          if r.$_RADIO_NAME is not @radio then r.setActive false
        @emit 'switch', name
      
      W::getActive = () -> @radio

      W::getActiveChild = () ->
        return @group.find (g) -> g.$_RADIO_NAME is @radio
      
      utils.boundableWidget W, '-switch',
        set: (val) -> @setActive val
        get: () -> @getActive()

  widgets.radio = createClass (if Gtk.selected is '4.0' then Gtk.CheckButton else Gtk.RadioButton),
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
    options: utils.convertOptions adjustment: (a) -> new Gtk.Adjustment a
    resolveNamespaceProps: ['adjustment']
    name: 'spin-button'

  widgets.comboBox = createClass Gtk.ComboBox,
    onInit: utils.initFn_FromOption 'bind'
    name: 'combo-box'
    take: (W) ->
      W::setState = (state) ->
      
      utils.boundableWidget W, '-change',
        set: (val) -> @setActive val
        get: () -> @getActive()

  widgets.comboBoxText = createClass Gtk.ComboBoxText,
    name: 'combo-box-text'
    take: (W) ->
      W::setTextItems = (items) ->
        @widget.removeAll()
        items.forEach (item) -> @widget.appendText item

      W::setActiveText = (text) ->
        found = false
        for i in [0...@widget.getNItems()]
          if @widget.getActiveText() == text
            @widget.setActive(i)
            found = true
            break
        unless found
          @widget.setActive(-1)

      W::getActiveText = () ->
        @widget.getActiveText()

      W::getTextItems = () ->
        items = []
        for i in [0...@widget.getNItems()]
          items.push @widget.getActiveText() if @widget.getActiveText()
        items

      W::removeAll = () ->
        @widget.removeAll()

  widgets.entry = createClass Gtk.Entry,
    bindOptions: ['bind']
    onInit: utils.initFn_FromOption 'bind'
    name: 'input'
    take: (W) ->
      utils.boundableWidget W, 'changed',
        set: (val) -> @widget.setText val
        get: () -> @widget.getText()

  widgets.searchEntry = createClass Gtk.SearchEntry,
    inherits: widgets.entry
    name: 'search'

  widgets.passwordEntry = createClass Gtk.PasswordEntry,
    inherits: widgets.entry
    name: 'password'

  widgets.entryBuffer = createClass Gtk.EntryBuffer,
    inherits: widgets.entry
    name: 'buffer-input'
    