import { WidgetState } from "./state.coffee"



export class WidgetStateStore
  constructor: (values) ->
    @_values = values
    for key, value of values then do (value) =>
        getters this, {
          ['$'+key]: () -> value.get()
          [key]: () -> value
        }
        setters this, {
          [key]: (val) -> value.set val
        }
    @

export createStoreFor = (ctx, wctx) ->
  store = {}
  store.prototype = {}

  store::new = (cb) ->
    ccc_tx = {
      state: wctx.state,
      ref: wctx.ref
      surge: wctx.surge
      Store: wctx.store
    }
    exceptionKeys = Object.keys ccc_tx
    cb.call(ccc_tx)
    store::derive ccc_tx, exceptionKeys
    
  store::derive = (object, exceptionKeys = []) ->
    str = {} # store
    for key, val of object
      if key in exceptionKeys then continue
      do (val) ->
        str[key] = if val instanceof WidgetState then val else wctx.state val
    return new WidgetStateStore str
  
  store::flux = (cb) ->
    s = store::new cb
    return Usage::create '@ui._context', (cb) ->
      return cb.call({...wctx, store: s}, ctx)

  store
