
class Archive
  constructor: -> 
    @items = {}
  register: (name, classFunction) ->
    @items[name] = classFunction
    this
  unregister: (name) -> 
    delete @items[name]
    this
  find: (name) ->
    @items[name]
  filter: (name) ->
    Object.keys @items
      .filter((key) ->
        key.startsWith(name) || key.startsWith('any.')
      ).map((name) =>
        { name: name.split('.').pop(), key: name, value: @items[name] }
      )

exports { Archive }