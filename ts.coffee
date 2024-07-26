using namespace imp('#./main', gtk: '4.0').setup ->
	using JSX, Widget::create
	using refine(Window) ->
	  alphabet = @states [1..10]
	  <box>
	    {
	      alphabet
	        .filter (letter) => letter isnt 'm'
	        .map (letter) => <text>{letter}</text>
	    }
	  </box>



