import { WidgetRef, WidgetState } from "../modules/state.coffee"
import { createStoreFor } from "../modules/store.coffee"


export createWindow = (ctx, options) ->
  window = if ctx.config.gtk is '4.0' then new ctx.Gtk.ApplicationWindow(ctx.gtk_app) else new ctx.Gtk.Window()
  window.setTitle if options.title? then options.title else 'Window'

  if options.closeOnQuit isnt false
    if ctx.config.gtk is '4.0'
      window.on 'close-request', ->
        ctx.appLoop.quit()
        process.exit(0)
    else
      window.on('delete-event', () => false)
      window.on 'destroy', ->
        ctx.Gtk.mainQuit()
        process.exit(0)

  _setChild = (child) => if ctx.config.gtk is '4.0' then window.setChild child else window.add child

  windowContext = { window }
  windowContext.setTitle = (title) => window.setTitle title
  windowContext.setChild = (child) ->
    if child instanceof ctx.Widget
      _setChild child.widget
    else
      _setChild child

  windowContext.titleBar = (titleBar) ->
    if titleBar instanceof ctx.Widget
      window.setTitlebar titleBar.widget
    else
      window.setTitlebar titleBar


  windowContext.show = -> if ctx.config.gtk is '4.0' then window.show() else window.showAll()
  windowContext.present = -> window.present()
  windowContext.hide = -> window.hide()

  target = emitter()

  windowContext.$$states = {};
  windowContext.$$renders = 0;
  windowContext.$$stateCount = 0;

  windowContext.state = (value) ->
    id = windowContext.$$stateCount
    windowContext.$$stateCount++
    return windowContext.$$states[id] if windowContext.$$states[id]?
    state = new WidgetState value
    windowContext.$$states[id] = state
    state.target.on 'set', ->
      target.emit 'update', state
      # windowContext.render()
    state

  windowContext.Store = createStoreFor ctx, windowContext
    
  windowContext.surge = (state, mapper) ->
    newState = windowContext.state mapper state.get()
    state.target.on 'set', (newVal) ->
      newState.set mapper newVal
    newState
  
  windowContext.ref = () -> new WidgetRef

  windowContext.on = (e, f) -> target.on e, f
  windowContext.off = (e, f) -> target.off e, f
  windowContext.emit = (e, f) -> target.emit e, f
  
  windowContext

export fixateWindow = (ctx, cb, windowContext) ->
  if ctx.config.gtk is '4.0'
    windowContext.show();
    windowContext.window.present() 

  windowContext.render = ->
    windowContext.$$renders++
    windowContext.$$stateCount = 0
    currentChild = windowContext.window.getChild()
    if currentChild?
      currentChild.wrappedByClass.emit('destroy') if currentChild.wrappedByClass?
    widget = cb.call(windowContext)
    unless widget && (widget instanceof ctx.Widget or widget instanceof ctx.Gtk.Widget) then return
    if widget?.__props?.title_bar
      windowContext.titleBar widget.__props.title_bar
    windowContext.setChild widget if widget?
  
  windowContext.render()
  windowContext.show() if ctx.config.gtk is '3.0'
  windowContext.emit 'ready'
