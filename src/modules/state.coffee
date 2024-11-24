
export class WidgetState
  _value: null
  target: {}
  constructor: (value) ->
    @_value = value
    @target = emitter()

    getters this, value: () => @get()
    setters this, value: (val) => @set(val)
    @

  get: () ->
    return this._value;

  format: (cb) ->
    return cb(this.get())

  set: (value, notify = true) ->
    this._value = value
    if notify then @target.emit('set', value)
    true

export class ArrayState extends WidgetState
  _operation: (name, fn, ...argss) ->
    @_gcomponent().surge this, (value) => value[name](...(if argss.length then argss else if fn then [(...args) => return fn(...args, @)] else [null]))
  _reset: () ->
    this.set(this.value)
    this
  map: (fn) ->
    @_operation('map', fn)
  unshift: (...items) ->
    this.value.unshift(...items)
    this._reset()
  push: (...items) ->
    this.value.push(...items)
    this._reset()
  pop: () ->
    this.value.pop()
    this._reset()
  shift: () ->
    this.value.shift()
    this._reset()
  filter: (fn) ->
    @_operation('filter', fn)
  reduce: (fn) ->
    @_operation('reduce', fn)
  reduceRight: (fn) ->
    @_operation('reduceRight', fn)
  flat: (fn) ->
    @_operation('flat', fn)
  flatMap: (fn) ->
    @_operation('flatMap', fn)
  sort: (fn) ->
    @_operation('sort', fn)
  reverse: () ->
    @_operation('reverse')
  concat: (...arrays) ->
    this.value.concat(...(arrays.map((arr) => if arr instanceof ArrayState then arr.get() else arr)))
    this._reset()
  at: (index, value) ->
    if value?
      this.value[index] = value
      this._reset()
    else
      return this.value.at(index)
  insertAt: (index, value) ->
    if index > this.value.length-1
      this.value.push(value)
    else
      this.value = [...this.value.slice(0, index), value, ...this.value.slice(index)]
    this._reset()
  remove: (value) ->
    if this.indexOf(value) > -1 then this.remove this.indexOf(value) else false
  removeAt: (index) ->
    this.value = [...this.value.slice(0, index), ...this.value.slice(index + 1)]
    this._reset()
  clear: () ->
    this.value = []
    this._reset()

  indexOf: (value) ->
    return this.value.indexOf(value)
  lastIndexOf: (value) ->
    return this.value.lastIndexOf(value)
  includes: (item) ->
    return this.value.includes(item)
  find: (fn) ->
    return this.value.find(fn)
  some: (finder) ->
    return this.value.some(finder)
  join: (joiner) ->
    return this.value.join(joiner)

  values: () ->
    return this.value.values()

  entries: () ->
    return this.value.entries()

  keys: () ->
    return this.value.keys()
  
  slice: (...args) ->
    @_operation('slice', null, ...args)
  splice: (...args) ->
    @_operation('splice', null, ...args)

export class WidgetRef extends WidgetState
  set: (value) ->
    super.set value
    @widget = value
  