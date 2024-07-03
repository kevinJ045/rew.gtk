using namespace imp('#./main', gtk: '4.0').setup ->
	using imp('./tcel').start(UI)
	using JSX, Widget::create
	using refine(Window) ->
		@state myState = 'sksksk'
		<box>
			<jsskas text={myState}>
				<text>Gi</text>
			</jsskas>
		</box>
