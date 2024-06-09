getGestureWidgets = (Context, createClass, widgets, archive, app, apploop, config, Gtk) ->
  widgets.gestureClick = createClass Gtk.GestureClick, 
    name: 'gestureClick'

  widgets.gestureDrag = createClass Gtk.GestureDrag, 
    name: 'gestureDrag'

  widgets.gestureLongPress = createClass Gtk.GestureLongPress, 
    name: 'gestureLongPress'

  widgets.gestureMultiPress = createClass Gtk.GestureMultiPress, 
    name: 'gestureMultiPress'

  widgets.gestureRotate = createClass Gtk.GestureRotate, 
    name: 'gestureRotate'

  widgets.gestureSwipe = createClass Gtk.GestureSwipe, 
    name: 'gestureSwipe'

  widgets.eventControllerKey = createClass Gtk.EventControllerKey, 
    name: 'eventControllerKey'

exports { getGestureWidgets }
