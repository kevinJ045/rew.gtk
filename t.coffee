using namespace imp('./main', gtk: '4.0').setup ->
	using JSX, Widget::create
	using refine(Window) ->
		<box>
			<text useBy={() -> print @}>SSS</text>
		</box>
