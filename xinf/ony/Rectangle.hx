/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.ony.type.Length;
import xinf.traits.FloatTrait;
import xinf.ony.traits.LengthTrait;

class Rectangle extends ElementImpl {

	static var tagName = "rect";
	
	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		width:new LengthTrait(),
		height:new LengthTrait(),
		rx:new LengthTrait(),
		ry:new LengthTrait(),
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Length).value; }
    function set_width( v:Float ) :Float { setTrait("width",new Length(v)); redraw(); return v; }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Length).value; }
    function set_height( v:Float ) :Float { setTrait("height",new Length(v)); redraw(); return v; }
	
    public var rx(get_rx,set_rx):Float;
    function get_rx() :Float { return getTrait("rx",Length).value; }
    function set_rx( v:Float ) :Float { setTrait("rx",new Length(v)); redraw(); return v; }
	
    public var ry(get_ry,set_ry):Float;
    function get_ry() :Float { return getTrait("ry",Length).value; }
    function set_ry( v:Float ) :Float { setTrait("ry",new Length(v)); redraw(); return v; }

	override public function getBoundingBox() : TRectangle {
		return { l:x, t:y, r:x+width, b:y+height };
	}

}
