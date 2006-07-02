package xinf.style;

signature Sides<T> {
	var l:T;
	var t:T;
	var r:T;
	var b:T;
}

signature Style {
	var padding :Sides<Float>;
	var background :xinf.ony.Color;
	var border :Sides<Float>;
	var color :xinf.ony.Color;
	var skin :String;
	var minWidth :Float;
	var textAlign :Float;
}
