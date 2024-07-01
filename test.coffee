using namespace imp('./main',
  gtk: '4.0',
  package: packageName
).setup ->
  using JSX as Widget::create
  using refine(Window) ->
    using refine(
      @Store::flux ->
        @active = true
        @popoverRef = @ref()
        @isOnToggle = true
        @isOnCheck = false
        @isOnSwitch = false
        @radioSwitch = 'male'
        @inputVal = 'This is a state'
        @progressVal = 0
    ) ->

      @on 'ready', _update = async =>
        if @store.$progressVal < 71
          await sleep 10
          @store.progressVal = @store.$progressVal + 1
          _update()

      <scrolled-window>
        <header-bar window-prop='title_bar'>
          <text>Start</text>
          <text>Title</text>
          <action-bar>
            <button><image icon="edit-copy" /></button>
            <button><image icon="edit-copy" /></button>
            <button><image icon="edit-copy" /></button>
          </action-bar>
        </header-bar>
        <box>
          <grid maxCols={10}>
            <button>sss</button>
            <button>sss</button>
            <button>sss</button>
            <button>sss</button>
          </grid>
          <stack active={@store.active}>
            <button on:click={() -> active.set 'Second'} name="First">Switch Two</button>
            <button on:click={() -> active.set 'Third'} name="Second">Switch Three</button>
            <button on:click={() -> active.set 'First'} name="Third">Switch One</button>
          </stack>
          <overlay>
            <text>Hello</text>
            <box>
              <text>Ov</text>
            </box>
          </overlay>
          <notebook on:switch-page={() => @store.progressVal.set(0) && _update()}>
            <box>
              <label>Tab 1</label>
              <box spacing={10}>
                <progress-bar show-text={true} fraction={@surge @store.progressVal, (val) -> val / 100}>
                  {@store.progressVal}
                </progress-bar>
                <level-bar inverted={true} min-value={0} max-value={100} value={@store.progressVal}></level-bar>
              </box>
            </box>
            <box name="t2">
              <box orientation="horizontal" spacing={10}>
                <image icon="edit-copy" />
                <label>Tab 2</label>
              </box>
              <box>
                <image pixel-size={100} file={realpath './assets/rew.png'} />
              </box>
            </box>
            <box name="hello">
              <label>Tab 3</label>
              <box>
                <popover useRef={@store.popoverRef}>
                  <box>
                    <label>Yo Yo Yo</label>
                  </box>
                </popover>
                <flow-box>
                  <box>
                    <label>{@store.isOnToggle}</label>
                    <toggleButton bind={@store.isOnToggle}>Toggle</toggleButton>
                  </box>
                  <box>
                    <label>{@store.isOnCheck}</label>
                    <check bind={@store.isOnCheck}>Check</check>
                  </box>
                  <box>
                    <label>{@store.isOnSwitch}</label>
                    <switch bind={@store.isOnSwitch}></switch>
                  </box>
                  <box>
                    <label>{@store.radioSwitch}</label>
                    <radio-group bind={@store.radioSwitch}>
                      <radio name="male">Male</radio>
                      <radio name="female">Female</radio>
                    </radio-group>
                  </box>
                  <box>
                    <spin-button adjustment:lower={1} adjustment:upper={10} adjustment:step-increment={1}></spin-button>
                  </box>
                </flow-box>
                <label>{@store.inputVal}</label>
                <search bind={@store.inputVal}></search>
                <button
                  on:click={() => @store.popoverRef.widget.popup()}>Opn</button>
              </box>
            </box>
          </notebook>
          <paned position={30} orientation='horizontal'>
            <box>
              <text>Left</text>
            </box>
            <box>
              <text>Right</text>
            </box>
          </paned>
        </box>
      </scrolled-window>