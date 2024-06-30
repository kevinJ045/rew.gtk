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
    isOnToggle = @state true
    isOnCheck = @state false
    isOnSwitch = @state false
    radioSwitch = @state 'male'
    <scrolled-window>
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
              <flow-box>
                <box>
                  <label>{isOnToggle}</label>
                  <toggleButton bind={isOnToggle}>Toggle</toggleButton>
                </box>
                <box>
                  <label>{isOnCheck}</label>
                  <check bind={isOnCheck}>Check</check>
                </box>
                <box>
                  <label>{isOnSwitch}</label>
                  <switch bind={isOnSwitch}></switch>
                </box>
                <box>
                  <label>{radioSwitch}</label>
                  <radio-group bind={radioSwitch}>
                    <radio name="male">Male</radio>
                    <radio name="female">Female</radio>
                  </radio-group>
                </box>
                <box>
                  <spin-button adjustment:lower={1} adjustment:upper={10} adjustment:step-increment={1}></spin-button>
                </box>
              </flow-box>
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
    </scrolled-window>