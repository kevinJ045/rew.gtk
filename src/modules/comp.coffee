import { WidgetRef, WidgetState, ArrayState } from "../modules/state.coffee"
import { createStoreFor } from "../modules/store.coffee"

export extendComponent = (ctx, component = {}) ->
  target = emitter()

  component.$$states = {};
  component.$$renders = 0;
  component.$$stateCount = 0;

  _doState = (value, stateClass) ->
    if value instanceof WidgetState then return value
    id = component.$$stateCount
    component.$$stateCount++
    return component.$$states[id] if component.$$states[id]?
    state = new stateClass value
    component.$$states[id] = state
    state.surge = (cb) -> component.surge state, cb
    state.target.on 'set', ->
      target.emit 'update', state
    state

  component.state = (value) ->
    return _doState value, WidgetState

  component.Store = createStoreFor ctx, component
    
  component.states = (value) ->
    state = _doState value, ArrayState
    state._gcomponent = -> component
    return state

  component.surge = (state, mapper) ->
    newState = (if state instanceof ArrayState then component.states else component.state) mapper state.get()
    state.target.on 'set', (newVal) ->
      newState.set mapper newVal
    newState
  
  component.stateOf = (state, type) ->
    # convert value
    cv = (v) =>
      return v
    if typeof state == 'function' && state.type instanceof int.type.constructor
      cv = state
      state = state.type
    if state instanceof int.type.constructor
      ref = type
      type = state
      state = ref
    if typeof type == 'function' && type.type instanceof int.type.constructor
      cv = type
      type = type.type
    
    verifyState = (val) ->
      val = cv val
      verification = typeis val, type, true
      unless verification[0]
        # required type
        rt = typeof type.defaultValue
        # given type
        gt = typeof val
        if rt == gt
          rt =  type.defaultValue.toString() 
          gt =  val.toString() 
        if verification[1]
          keysNotFound = Object.keys(verification[1]).filter((key) -> verification[1][key].not_found)
          typeMismatch = Object.keys(verification[1]).filter((key) -> verification[1][key].type_mismatch).map((key) => [key, verification[1][key].type_mismatch]).pop()
          throw if typeMismatch? then new TypeError("Key: #{typeMismatch[0]} is of type #{typeMismatch[1]}") else new TypeError("Missing keys: #{keysNotFound}")
        else
          throw new TypeError("State value is not the right type.\nRequired #{rt} and given is #{gt}");
      return val
    
    return component.surge component.state(state), verifyState


    
  
  component.ref = () -> new WidgetRef

  component.on = (e, f) -> target.on e, f
  component.off = (e, f) -> target.off e, f
  component.emit = (e, f) -> target.emit e, f
  component
