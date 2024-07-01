import { createWidgetClass } from "../widgets/widgets.coffee"
import { UiContext } from "../models/ctx.coffee"
import { createWindow, fixateWindow } from "../models/winctx.coffee"

export createUiApp = (options) ->
  ctx = new UiContext options

  ctx.Widget = createWidgetClass(ctx)

  ctx.refine = (cb) ->
    if typeof cb == "function"
      namespace.group [ctx, cb], use: () -> using namespace this
    else
      (cb2) -> Usage::group cb, cb2

  ctx.Window = Usage::create 'ui.window', (options, cb) ->
    if typeof options is "function" and not cb
      cb = options
      options = {}

    windowContext = createWindow ctx, options
    fixateWindow ctx, cb, windowContext
    windowContext
  ctx.Window.prototype = {}
  ctx.Window::create = (options) -> createWindow ctx, options
  
  ctx.setup = (cb) ->
    return namespace.group [
      ctx
      if ctx.config.gtk is '4.0' then Function "
        gtk_app.on('activate', function(){
          (#{cb})();
          appLoop.run()
        });
      " else cb
    ], {
      onAfterUse: ->
        ctx.startMain()
    }

  return ctx