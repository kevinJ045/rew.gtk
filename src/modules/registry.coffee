import { extendComponent } from "./comp.coffee"
###*
 * @params ctx {Record<string, any>}
 * @params elements {[]}
*###
export getRegistry = (ctx) ->
  Registry = {}

  _register = (name, item) =>
    ctx.elements[name.toLowerCase().replace(/_(.)/g, '-$1')] = item

  ctx.Component = (func, name) ->
    if typeof func == "string"
      ref = func
      func = name
      name = ref
    func.__name = name
    func.__isJSXComponent = true
    func.__context = extendComponent ctx, {
      __name: name,
      __self: func
      __isComponent: true
    }
    return func


  Registry.register = (...toRegister) ->
    for r in toRegister
      if r.prototype instanceof ctx.Widget
        _register r::name, r2
      else if typeof r == 'function' and r.__isJSXComponent
        _register r.__name or r.name, r
      else if typeof r == 'function'
        result = r(ctx)
        Registry.register result
      else if Array.isArray r
        Registry.register(...r)

  Registry.with = (...items) ->
    Registry.register ...items

  ctx.Registry = Registry
    
