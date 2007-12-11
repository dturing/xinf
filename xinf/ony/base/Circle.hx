package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;
import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class Circle extends ElementImpl {

	static var TRAITS = {
		cx:new FloatTrait(),
		cy:new FloatTrait(),
		 r:new FloatTrait(),
	};

    public var cx(get_cx,set_cx):Float;
    function get_cx() :Float { return getTrait("cx",Float); }
    function set_cx( v:Float ) :Float { redraw(); return setTrait("cx",v); }

    public var cy(get_cy,set_cy):Float;
    function get_cy() :Float { return getTrait("cy",Float); }
    function set_cy( v:Float ) :Float { redraw(); return setTrait("cy",v); }

    public var r(get_r,set_r):Float;
    function get_r() :Float { return getTrait("r",Float); }
    function set_r( v:Float ) :Float { redraw(); return setTrait("r",v); }

	override public function getBoundingBox() : TRectangle {
		return { l:cx-r, t:cy-r, r:cx+r, b:cy+r };
	}

}