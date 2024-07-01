
export class WidgetState
  _value: null
  target: {}
  constructor: (value) ->
    @_value = value
    @target = emitter()
    @

  get: () ->
    return this._value;

  set: (value, notify = true) ->
    this._value = value
    if notify then @target.emit('set', value)
    true

export class WidgetRef extends WidgetState
  set: (value) ->
    super.set value
    @widget = value
  