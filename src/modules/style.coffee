
export initStyle = (ctx, options) ->
  ctx.Style = {
    applyTo: (elt, provider) ->
      if typeof provider == 'string'
        provider = ctx.Style.provider provider
      if elt is 'global'
        ctx.Gtk.StyleContext.addProviderForDisplay(
          ctx.Gdk.Display.getDefault(),
          provider,
          ctx.Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )
      else if elt instanceof ctx.Gtk.Widget
        elt.getStyleContext().addProvider(provider, ui.Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
      else if elt instanceof ctx.Widget
        elt.widget.getStyleContext().addProvider(provider, ui.Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
      true
    provider: (css) ->
      if css.startsWith 'file://'
        css = read css
      provider = new ctx.Gtk.CssProvider()
      provider.loadFromString css
      provider
    global: (provider) ->
      ctx.Style.applyTo 'global', provider
    merge: (...styles) ->
      mainStyle = styles.pop()
      styles.forEach (style) ->
        mainStyle = deepMerge style, mainStyle 
      mainStyle

  }