package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;
import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class Line extends ElementImpl {

	static var TRAITS = {
		x1:new FloatTrait(),
		y1:new FloatTrait(),
		x2:new FloatTrait(),
		y2:new FloatTrait(),
	};
	
    public var x1(get_x1,set_x1):Float;
    function get_x1() :Float { return getTrait("x1",Float); }
    function set_x1( v:Float ) :Float { redraw(); return setTrait("x1",v); }

    public var y1(get_y1,set_y1):Float;
    function get_y1() :Float { return getTrait("y1",Float); }
    function set_y1( v:Float ) :Float { redraw(); return setTrait("y1",v); }

    public var x2(get_x2,set_x2):Float;
    function get_x2() :Float { return getTrait("x2",Float); }
    function set_x2( v:Float ) :Float { redraw(); return setTrait("x2",v); }

    public var y2(get_y2,set_y2):Float;
    function get_y2() :Float { return getTrait("y2",Float); }
    function set_y2( v:Float ) :Float { redraw(); return setTrait("y2",v); }

	override public function getBoundingBox() : TRectangle {
		return { l:x1, t:y1, r:x2, b:y2 };
	}

}
