package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;
import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class Rectangle extends ElementImpl {

	static var TRAITS = {
		x:new FloatTrait(),
		y:new FloatTrait(),
		width:new FloatTrait(),
		height:new FloatTrait(),
		rx:new FloatTrait(),
		ry:new FloatTrait(),
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Float); }
    function set_x( v:Float ) :Float { redraw(); return setTrait("x",v); }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Float); }
    function set_y( v:Float ) :Float { redraw(); return setTrait("y",v); }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Float); }
    function set_width( v:Float ) :Float { redraw(); return setTrait("width",v); }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Float); }
    function set_height( v:Float ) :Float { redraw(); return setTrait("height",v); }
	
    public var rx(get_rx,set_rx):Float;
    function get_rx() :Float { return getTrait("rx",Float); }
    function set_rx( v:Float ) :Float { redraw(); return setTrait("rx",v); }
	
    public var ry(get_ry,set_ry):Float;
    function get_ry() :Float { return getTrait("ry",Float); }
    function set_ry( v:Float ) :Float { redraw(); return setTrait("ry",v); }

	override public function getBoundingBox() : TRectangle {
		return { l:x, t:y, r:x+width, b:y+height };
	}

}
