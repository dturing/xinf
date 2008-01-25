/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class LinearGradient extends Gradient {

	static var TRAITS = {
		x1:new FloatTrait(0),
		y1:new FloatTrait(0),
		x2:new FloatTrait(1),
		y2:new FloatTrait(0),
	};
	
    public var x1(get_x1,set_x1):Float;
    function get_x1() :Float { return getTrait("x1",Float); }
    function set_x1( v:Float ) :Float { return setTrait("x1",v); }

    public var y1(get_y1,set_y1):Float;
    function get_y1() :Float { return getTrait("y1",Float); }
    function set_y1( v:Float ) :Float { return setTrait("y1",v); }

    public var x2(get_x2,set_x2):Float;
    function get_x2() :Float { return getTrait("x2",Float); }
    function set_x2( v:Float ) :Float { return setTrait("x2",v); }

    public var y2(get_y2,set_y2):Float;
    function get_y2() :Float { return getTrait("y2",Float); }
    function set_y2( v:Float ) :Float { return setTrait("y2",v); }

}
