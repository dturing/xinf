/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.ony.traits.LengthTrait;
import xinf.ony.type.Length;

class Line extends ElementImpl {

	static var tagName = "line";

	static var TRAITS = {
		x1:new LengthTrait(),
		y1:new LengthTrait(),
		x2:new LengthTrait(),
		y2:new LengthTrait(),
	};
	
    public var x1(get_x1,set_x1):Float;
    function get_x1() :Float { return getTrait("x1",Length).value; }
    function set_x1( v:Float ) :Float { setTrait("x1",new Length(v)); redraw(); return v; }

    public var y1(get_y1,set_y1):Float;
    function get_y1() :Float { return getTrait("y1",Length).value; }
    function set_y1( v:Float ) :Float { setTrait("y1",new Length(v)); redraw(); return v; }

	public var x2(get_x2,set_x2):Float;
    function get_x2() :Float { return getTrait("x2",Length).value; }
    function set_x2( v:Float ) :Float { setTrait("x2",new Length(v)); redraw(); return v; }

    public var y2(get_y2,set_y2):Float;
    function get_y2() :Float { return getTrait("y2",Length).value; }
    function set_y2( v:Float ) :Float { setTrait("y2",new Length(v)); redraw(); return v; }

	override public function getBoundingBox() : TRectangle {
		return { l:x1, t:y1, r:x2, b:y2 };
	}

}
