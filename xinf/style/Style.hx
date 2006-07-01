package xinf.style;

signature Sides<T> {
	var l:T;
	var t:T;
	var r:T;
	var b:T;
}

signature SidesAndCorners<T> {
	var l:T;
	var t:T;
	var r:T;
	var b:T;
	var tl:T;
	var tr:T;
	var bl:T;
	var br:T;
}

signature BorderStyle {
	var width :Float;
	function make( e:xinf.ony.Element ) :Border;
}

interface Border {
	var width :Float;
	function setLeft( x:Float, y:Float, h:Float ):Void;
	function setRight( x:Float, y:Float, h:Float ):Void;
	function setTop( x:Float, y:Float, w:Float ):Void;
	function setBottom( x:Float, y:Float, w:Float ):Void;
	function set( x:Float, y:Float ):Void;
}

signature Style {
	var padding :Sides<Float>;
	var border :SidesAndCorners<BorderStyle>;
	var background :xinf.ony.Color;
	var color :xinf.ony.Color;
	var minWidth :Float;
	var hAlign :Float;
}
