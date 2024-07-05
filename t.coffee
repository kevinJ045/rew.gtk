using namespace imp('#./main', gtk: '4.0').setup ->
	using JSX, Widget::create
	using refine(Window) ->

		str myString = 'my str'
		@stateOf(str) myState = 'Add'
		@states stringState = [
			myString
			'something else'
		]

		<box>
			<box>
				{
					stringState
						.filter (string) -> string isnt myString
						.map (string) -> <text>{string}</text>
				}
			</box>
			<button on:click={
				() ->
					if stringState.includes('hi')
					then stringState.pop()
					else stringState.push('hi')

					myState.set(
						if myState.get() == 'Add'
						then 'Remove'
						else 'Add'
					)
			}>{myState}</button>
		</box>


