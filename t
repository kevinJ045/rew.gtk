var getContainerWidgets;var indexOf = [].indexOf;
getContainerWidgets = function(createClass, widgets, Gtk, WidgetState) {

  var switchOrientation, alignments, policies, onInit;

  switchOrientation = function(options) { return ({ ...options, orientation: (options.orientation === 'horizontal' || options.orientation === 'h'? Gtk.Orientation.HORIZONTAL : Gtk.Orientation.VERTICAL) }) }

  widgets.box = createClass(Gtk.Box, {
    options: switchOrientation,
    name: 'box',
    take: function(W) {
      return W.prototype._add = function(child) { return this.widget.append(child) }
    },
  })

  widgets.grid = createClass(Gtk.Grid, {
    name: 'grid',
    exclude: ['maxCols'],
    onInit: function() {
      this.currentCol = 0
      return this.currentRow = 1
    },
    take: function(W) {
      W.prototype.attach = function(child, left, top, width, height) {
        return this.widget.attach(child, left, top, width, height)
      }
      return W.prototype._add = function(child) {
        let ref;if (this.options?.maxCols != null) ref = this.options.maxCols; else ref = 3;this.maxCols = ref
        if (this.currentCol >= this.maxCols) {
          this.currentCol = 0
          this.currentRow += 1
        }
        this.attach(child, this.currentCol, this.currentRow, 1, 1)
        return this.currentCol += 1
      }
    },
  })

  widgets.stack = createClass(Gtk.Stack, {
    name: 'stack',
    exclude: ['active'],
    onInit: function(_, options) {
      this.active = ''
      this.childMap = new Map()
      if (options?.active != null) { return this.switch(options.active) };return
    },
      
    take: function(W) {
      W.prototype._add = function(child) {
        var name;
        if (!child.wrappedByClass?.options?.name) {
          throw new Error('Pass a name for every stack child')
        }
        name = child.wrappedByClass.options.name
        this.widget.addTitled(child, name, name)
        this.childMap.set(name, child)
        if (this.active === name) {
          return this.switch(name)
        };return
      }
      W.prototype.onProp('active', function(active) {
        return this.switch(active)
      })
      W.prototype.switch = function(name) {
        this.active = name
        if (this.childMap.has(name)) {
          return this.widget.setVisibleChildName(name)
        };return
      }
      return W.prototype.remove = function(name) {
        var child;
        if (this.childMap.has(name)) {
          child = this.childMap.get(name)
          this.widget.remove(child)
          return this.childMap.delete(name)
        };return
      }
    },
  })

  alignments = {
    'start': Gtk.Align.START,
    'end': Gtk.Align.END,
    'center': Gtk.Align.CENTER,
    'baseline': Gtk.Align.BASELINE,
    'fill': Gtk.Align.FILL
  }

  widgets.overlay = createClass(Gtk.Overlay, {
    name: 'overlay',
    exclude: ['halign', 'valign', 'marginStart', 'marginTop', 'marginBottom', 'marginEnd'],
    onInit: function(_, options) {
      var i;
      this.overlays = []
      const results=[];for (let ref1 = this._excludeOptions, i1 = 0, len = ref1.length; i1 < len; i1++) {i = ref1[i1];
        if (indexOf.call(options, i) >= 0) {
          results.push(this.setProp(i, options[i]))
        } else {results.push(void 0)}
      };return results;
    },
    take: function(W) {
      W.prototype.setBaseWidget = function(baseWidget) {
        if (this.base != null) {
          this.widget.remove(this.base)
        }
        this.widget.setChild(baseWidget)
        return this.base = baseWidget
      }
      
      W.prototype.addOverlay = function(overlayWidget) {
        this.widget.addOverlay(overlayWidget)
        return this.overlays.push({ widget: overlayWidget })
      }
      
      W.prototype._add = function(child) {
        if (this.base != null) {
          return this.addOverlay(child)
        }
        else {
          return this.setBaseWidget(child)
        }
      }

      W.prototype.onProp('halign', function(align) {
        return this.widget.setHalign(alignments[align])
      })

      W.prototype.onProp('valign', function(align) {
        return this.widget.setHalign(alignments[align])
      })

      W.prototype.onProp('marginStart', function(margin) {
        return this.widget.setHalign(((margin != null) && !isNaN(margin)? margin : 0))
      })

      W.prototype.onProp('marginTop', function(margin) {
        return this.widget.setHalign(((margin != null) && !isNaN(margin)? margin : 0))
      })

      W.prototype.onProp('marginBottom', function(margin) {
        return this.widget.setHalign(((margin != null) && !isNaN(margin)? margin : 0))
      })

      W.prototype.onProp('marginEnd', function(margin) {
        return this.widget.setHalign(((margin != null) && !isNaN(margin)? margin : 0))
      })
        
      return W.prototype.removeOverlay = function(overlayWidget) {
        this.widget.remove(overlayWidget)
        return this.overlays = this.overlays.filter(function(overlay) { return overlay.widget !== overlayWidget })
      }
    },
  })

  widgets.paned = createClass(Gtk.Paned, {
    options: switchOrientation,
    name: 'paned',
    onInit: function(_, options) {
      return this.children = 0
    },
    take: function(W) {
      return W.prototype._add = function(child) {
        if (this.children === 0) {
          this.widget.setStartChild(child)
          return this.children = 1
        }
        else {
          this.widget.setEndChild(child)
          return this.children = 0
        }
      }
    },
  })

  policies = {
    'auto': Gtk.PolicyType.AUTOMATIC,
    'automatic': Gtk.PolicyType.AUTOMATIC,
    'always': Gtk.PolicyType.ALWAYS,
    'never': Gtk.PolicyType.NEVER,
    'external': Gtk.PolicyType.EXTERNAL  // Note: Primarily for other widgets, not standard for scrollbars in ScrolledWindow.
  }

  widgets.scrolledWindow = createClass(Gtk.ScrolledWindow, {
    name: 'scrolledWindow',
    exclude: ['vertical', 'horizontal'],
    options: function(options, unMappedOptions) {
      var o;
      o = {...options}
      if (unMappedOptions.horizontal) {
        o.hscrollbar_policy = policies[unMappedOptions.horizontal]
      }
      if (unMappedOptions.vertical) {
        o.vscrollbar_policy = policies[unMappedOptions.vertical]
      }
      return o
    },
    take: function(W) {
      // override
      return W.prototype._add = function(child) {
        return this.widget.setChild(child)
      }
    },
  })

  widgets.notebook = createClass(Gtk.Notebook, {
    name: 'notebook',
    exclude: ['active'],
  })(
    onInit = function(_, options) {
      this.tabs = {}
      return this.active = options.active
    },
    {take: function(W) {
      // override
      W.prototype._add = function(child) {
        var label, tab, tabIndex, tabID;
        let ref2;if (child.wrappedByClass.options?.tab != null) ref2 = child.wrappedByClass.options.tab; else ref2 = 'tab-' + Object.keys(this.tabs).length;tabID = ref2
        label = child.wrappedByClass.widget_children[0]
        tab = child.wrappedByClass.widget_children[1]
        if (!(label || tab)) {
          throw new Error('A notebook child has to have two children')
        }
        child.remove(label.widget)
        child.remove(tab.widget)
        tabIndex = this.widget.appendPage(tab.widget, label.widget)
        if (!(this.active != null)) { this.active = tabIndex }
        return this.tabs[tabID] = tabIndex
      }

      return W.prototype.onProp('active', function(active) {
        return this.widget.setCurrentPage(this.tabs[active] || active)
      })
    }},)
      
      



  widgets.popover = createClass(Gtk.Popover, {
    name: 'popover',
  })

  widgets.flowBox = createClass(Gtk.FlowBox, {
    name: 'flowBox',
  })

  return widgets.listBox = createClass(Gtk.ListBox, {
    name: 'listBox',
  })
}


exports({ getContainerWidgets })

