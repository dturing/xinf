/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.ony.traits.LengthTrait;
import xinf.ony.type.Length;

class Circle extends ElementImpl {

	static var tagName = "circle";

	static var TRAITS = {
		cx:new LengthTrait(),
		cy:new LengthTrait(),
		 r:new LengthTrait(),
	};

    public var cx(get_cx,set_cx):Float;
    function get_cx() :Float { return getTrait("cx",Length).value; }
    function set_cx( v:Float ) :Float { setTrait("cx",new Length(v)); redraw(); return v; }

    public var cy(get_cy,set_cy):Float;
    function get_cy() :Float { return getTrait("cy",Length).value; }
    function set_cy( v:Float ) :Float { setTrait("cy",new Length(v)); redraw(); return v; }

    public var r(get_r,set_r):Float;
    function get_r() :Float { return getTrait("r",Length).value; }
    function set_r( v:Float ) :Float { setTrait("r",new Length(v)); redraw(); return v; }

	override public function getBoundingBox() : TRectangle {
		return { l:cx-r, t:cy-r, r:cx+r, b:cy+r };
	}

}