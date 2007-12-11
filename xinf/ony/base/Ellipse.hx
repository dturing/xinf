package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;
import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class Ellipse extends ElementImpl {

	static var TRAITS = {
		cx:new FloatTrait(),
		cy:new FloatTrait(),
		rx:new FloatTrait(),
		ry:new FloatTrait(),
	};

    public var cx(get_cx,set_cx):Float;
    function get_cx() :Float { return getTrait("cx",Float); }
    function set_cx( v:Float ) :Float { redraw(); return setTrait("cx",v); }

    public var cy(get_cy,set_cy):Float;
    function get_cy() :Float { return getTrait("cy",Float); }
    function set_cy( v:Float ) :Float { redraw(); return setTrait("cy",v); }

    public var rx(get_rx,set_rx):Float;
    function get_rx() :Float { return getTrait("rx",Float); }
    function set_rx( v:Float ) :Float { redraw(); return setTrait("rx",v); }

    public var ry(get_ry,set_ry):Float;
    function get_ry() :Float { return getTrait("ry",Float); }
    function set_ry( v:Float ) :Float { redraw(); return setTrait("ry",v); }

	override public function getBoundingBox() : TRectangle {
		return { l:cx-rx, t:cy-ry, r:cx+rx, b:cy+ry };
	}

}