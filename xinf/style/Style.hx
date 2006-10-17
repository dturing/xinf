package xinf.style;

import xinf.erno.Color;

typedef Sides<T> = {
	var l:T;
	var t:T;
	var r:T;
	var b:T;
}

typedef Style = {
	var padding :Sides<Float>;
	var border :Sides<Float>;
	
	var background :Color;
	var color :Color;
	
	var minWidth :Float;
	var textAlign :Float;
	var verticalAlign :Float;
}
