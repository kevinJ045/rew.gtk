import { WidgetRef, WidgetState } from "../modules/state.coffee"
import { createStoreFor } from "../modules/store.coffee"

export extendComponent = (ctx, component = {}) ->
  target = emitter()

  component.$$states = {};
  component.$$renders = 0;
  component.$$stateCount = 0;

  component.state = (value) ->
    id = component.$$stateCount
    component.$$stateCount++
    return component.$$states[id] if component.$$states[id]?
    state = new WidgetState value
    component.$$states[id] = state
    state.target.on 'set', ->
      target.emit 'update', state
    state

  component.Store = createStoreFor ctx, component
    
  component.surge = (state, mapper) ->
    newState = component.state mapper state.get()
    state.target.on 'set', (newVal) ->
      newState.set mapper newVal
    newState
  
  component.ref = () -> new WidgetRef

  component.on = (e, f) -> target.on e, f
  component.off = (e, f) -> target.off e, f
  component.emit = (e, f) -> target.emit e, f
  component
