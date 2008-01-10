/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.ony.traits.LengthTrait;
import xinf.ony.type.Length;

class Ellipse extends ElementImpl {

	static var tagName = "ellipse";

	static var TRAITS = {
		cx:new LengthTrait(),
		cy:new LengthTrait(),
		rx:new LengthTrait(),
		ry:new LengthTrait(),
	};

    public var cx(get_cx,set_cx):Float;
    function get_cx() :Float { return getTrait("cx",Length).value; }
    function set_cx( v:Float ) :Float { setTrait("cx",new Length(v)); redraw(); return v; }

    public var cy(get_cy,set_cy):Float;
    function get_cy() :Float { return getTrait("cy",Length).value; }
    function set_cy( v:Float ) :Float { setTrait("cy",new Length(v)); redraw(); return v; }

    public var rx(get_rx,set_rx):Float;
    function get_rx() :Float { return getTrait("rx",Length).value; }
    function set_rx( v:Float ) :Float { setTrait("rx",new Length(v)); redraw(); return v; }

	public var ry(get_ry,set_ry):Float;
    function get_ry() :Float { return getTrait("ry",Length).value; }
    function set_ry( v:Float ) :Float { setTrait("ry",new Length(v)); redraw(); return v; }

	override public function getBoundingBox() : TRectangle {
		return { l:cx-rx, t:cy-ry, r:cx+rx, b:cy+ry };
	}

}
