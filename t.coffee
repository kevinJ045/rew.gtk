using namespace imp('./main', gtk: '4.0').setup ->
	using JSX, Widget::create
	using refine(Window) ->
	  isTrue = @state true
	  inputVal = @state 'default value'
	  <box>
		<text>{isTrue}</text>
		<check bind={isTrue}>Toggle</check>

		<text>{inputVal}</text>
		<input bind={inputVal}></input>
	  </box>
