import { getUtils } from "./utils.coffee"

export getContainerWidgets = (createClass, widgets, Gtk, WidgetState) ->

  utils = getUtils Gtk

  widgets.box = createClass Gtk.Box,
    options: utils.switchOrientation
    name: 'box'
    take: (W) ->
      W::_add = (child) -> if Gtk.selected == '4.0' then @widget.append child else @widget.add child

  widgets.grid = createClass Gtk.Grid,
    name: 'grid'
    exclude: ['maxCols']
    onInit: () ->
      @currentCol = 0
      @currentRow = 1
    take: (W) ->
      W::attach = (child, left, top, width, height) ->
        @widget.attach(child, left, top, width, height)
      W::_add = (child) ->
        @maxCols = if @options?.maxCols? then @options.maxCols else 3
        if @currentCol >= @maxCols
          @currentCol = 0
          @currentRow += 1
        @attach(child, @currentCol, @currentRow, 1, 1)
        @currentCol += 1

  widgets.stack = createClass Gtk.Stack,
    name: 'stack',
    exclude: ['active']
    onInit: (_, options) ->
      @active = ''
      @childMap = new Map()
      @switch options.active if options?.active?
      
    take: (W) ->
      W::_add = (child) ->
        unless child.wrappedByClass?.options?.name
          throw new Error 'Pass a name for every stack child'
        name = child.wrappedByClass.options.name
        @widget.addTitled(child, name, name)
        @childMap.set(name, child)
        if @active == name
          @switch name
      W::onProp 'active', (active) ->
        @switch active
      W::switch = (name) ->
        @active = name
        if @childMap.has name
          @widget.setVisibleChildName(name)
      W::remove = (name) ->
        if @childMap.has(name)
          child = @childMap.get(name)
          @widget.remove child
          @childMap.delete(name)

  widgets.overlay = createClass Gtk.Overlay,
    name: 'overlay'
    exclude: ['halign', 'valign', 'marginStart', 'marginTop', 'marginBottom', 'marginEnd']
    onInit: (_, options) ->
      @overlays = []
      for i in @_excludeOptions
        if i in options
          @setProp i, options[i]
    take: (W) ->
      W::setBaseWidget = (baseWidget) ->
        if @base?
          @widget.remove @base
        if Gtk.selected is '4.0'
          @widget.setChild baseWidget
        else
          @widget.add baseWidget
        @base = baseWidget
      
      W::addOverlay = (overlayWidget) ->
        @widget.addOverlay overlayWidget
        @overlays.push { widget: overlayWidget }
      
      W::_add = (child) ->
        if @base?
          @addOverlay child
        else
          @setBaseWidget child

      W::onProp 'halign', (align) ->
        @widget.setHalign utils.alignments[align]

      W::onProp 'valign', (align) ->
        @widget.setHalign utils.alignments[align]

      W::onProp 'marginStart', (margin) ->
        @widget.setHalign if margin? and not isNaN margin then margin else 0

      W::onProp 'marginTop', (margin) ->
        @widget.setHalign if margin? and not isNaN margin then margin else 0

      W::onProp 'marginBottom', (margin) ->
        @widget.setHalign if margin? and not isNaN margin then margin else 0

      W::onProp 'marginEnd', (margin) ->
        @widget.setHalign if margin? and not isNaN margin then margin else 0
        
      W::removeOverlay = (overlayWidget) ->
        @widget.remove overlayWidget
        @overlays = @overlays.filter (overlay) -> overlay.widget != overlayWidget

  widgets.paned = createClass Gtk.Paned,
    options: utils.switchOrientation
    name: 'paned'
    onInit: (_, options) ->
      @children = 0
    take: (W) ->
      W::_add = (child) ->
        if @children == 0
          if Gtk.selected is '4.0'
            @widget.setStartChild child
          else
            @widget.add1 child
          @children = 1
        else
          if Gtk.selected is '4.0'
            @widget.setEndChild child
          else
            @widget.add2 child
          @children = 0

  widgets.scrolledWindow = createClass Gtk.ScrolledWindow,
    name: 'scrolledWindow',
    exclude: ['vertical', 'horizontal']
    options: (options, unMappedOptions) ->
      o = {...options}
      if unMappedOptions.horizontal
        o.hscrollbar_policy = utils.policies[unMappedOptions.horizontal]
      if unMappedOptions.vertical
        o.vscrollbar_policy = utils.policies[unMappedOptions.vertical]
      o
    take: (W) ->
      # override
      W::_add = (child) ->
        if Gtk.selected is '4.0'
          @widget.setChild child
        else
          @widget.add child
        

  widgets.notebook = createClass Gtk.Notebook,
    name: 'notebook'
    exclude: ['active']
    onInit: (_, options) ->
      @tabs = {}
      @active = options.active
    take: (W) ->
      # override
      W::_add = (child) ->
        tabID = if child.wrappedByClass.options?.name? then child.wrappedByClass.options.name else 'tab-' + Object.keys(@tabs).length
        label = child.wrappedByClass.widget_children[0]
        tab = child.wrappedByClass.widget_children[1]
        unless label or tab
          throw new Error 'A notebook child has to have two children'
        child.remove label.widget
        child.remove tab.widget
        tabIndex = @widget.appendPage(tab.widget, label.widget)
        @tabs[tabID] = tabIndex
        @active = tabID unless @active?

        if @active && tabID == @active
          @widget.setCurrentPage tabIndex

      W::onProp 'active', (active) ->
        @widget.setCurrentPage @tabs[active] || active


  widgets.popover = createClass Gtk.Popover,
    options: (o) -> { ...o, position: utils.positions[o.position] or utils.positions.bottom }
    name: 'popover'
    onInit: () ->
      @$_isGhostWidget = true if Gtk.selected is '3.0'
    take: (W) ->
      # override
      W::_add = (child) ->
        if Gtk.selected is '4.0'
          @widget.setChild child
        else
          @widget.add child

      getters W, isUp: () -> @widget.isVisible()

      W::popup = () -> @widget.popup()
      W::popdown = () -> @widget.popdown()

  widgets.flowBox = createClass Gtk.FlowBox,
    name: 'flowBox'
    take: (W) ->
      # override
      W::_add = (child) ->
        @widget.insert child, @widget_children.length


  widgets.listBox = createClass Gtk.ListBox,
    name: 'listBox'
