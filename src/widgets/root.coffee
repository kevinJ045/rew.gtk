

getRoot = (Context, archive, widgets, Gtk) -> 
  class Root extends Context
  root = new Root
  root.register = (name, handler) ->
    archive.register name, handler
  root.getWidgets = () -> widgets
  root.extends = (name, handler) ->
    archive.register name, widgets.base::extends handler Gtk, widgets 
  root

exports { getRoot }