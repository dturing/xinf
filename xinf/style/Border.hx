package xinf.style;

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
