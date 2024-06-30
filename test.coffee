using namespace imp('./main',
  gtk: '4.0',
  package: app.config.manifest.package
).setup ->
  using JSX as Widget::create
  CustomEl = (props, name) ->
    <label>{name}</label>
  using refine(Window) ->
    active = @state 'First'
    popoverRef = @ref()
    <scrolledWindow>
      <box>
        <grid maxCols={10}>
          <button>sss</button>
          <button>sss</button>
          <button>sss</button>
          <button>sss</button>
        </grid>
        <stack active={active}>
          <button onClicked={() -> active.set 'Second'} name="First">Switch Two</button>
          <button onClicked={() -> active.set 'Third'} name="Second">Switch Three</button>
          <button onClicked={() -> active.set 'First'} name="Third">Switch One</button>
        </stack>
        <overlay>
          <text>Hello</text>
          <box>
            <text>Ov</text>
          </box>
        </overlay>
        <notebook active="hello">
          <box>
            <label>Tab 1</label>
            <box>
              <label>Content 1</label>
            </box>
          </box>
          <box name="hello">
            <label>Tab 2</label>
            <box>
              <popover useRef={popoverRef}>
                <box>
                  <label>Yo Yo Yo</label>
                </box>
              </popover>
              <flowBox>
                {
                  <button>{i}</button> for i in [0..10]
                }
              </flowBox>
              <toggleButton>I am togglable</toggleButton>
              <label>Content 2</label>
              <button
                onClick={() -> popoverRef.widget.popup()}>Opn</button>
            </box>
          </box>
        </notebook>
        <paned position={30} orientation='horizontal'>
          <box>
            <text>LEft</text>
          </box>
          <box>
            <text>Right</text>
          </box>
        </paned>
      </box>
    </scrolledWindow>