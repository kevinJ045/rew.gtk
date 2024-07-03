
export start = (UI) ->
  new Usage '', () ->
    using namespace UI, ->
      using JSX, Widget::create
      Component('jsskas') El = (props, ...children) ->
        <box orientation={props.orientation}>
          {children}
        </box>
      Registry.register El