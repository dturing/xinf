/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class RadialGradient extends Gradient {
	
	static var TRAITS = {
		cx:new FloatTrait(.5),
		cy:new FloatTrait(.5),
		 r:new FloatTrait(.5),
		fx:new FloatTrait(.5),
		fy:new FloatTrait(.5),
	};
	
    public var cx(get_cx,set_cx):Float;
    function get_cx() :Float { return getTrait("cx",Float); }
    function set_cx( v:Float ) :Float { return setTrait("cx",v); }

    public var cy(get_cy,set_cy):Float;
    function get_cy() :Float { return getTrait("cy",Float); }
    function set_cy( v:Float ) :Float { return setTrait("cy",v); }

    public var r(get_r,set_r):Float;
    function get_r() :Float { return getTrait("r",Float); }
    function set_r( v:Float ) :Float { return setTrait("r",v); }
/*
    public var fx(get_fx,set_fx):Float;
    function get_fx() :Float { return getTrait("fx",Float); }
    function set_fx( v:Float ) :Float { return setTrait("fx",v); }

    public var fy(get_fy,set_fy):Float;
    function get_fy() :Float { return getTrait("fy",Float); }
    function set_fy( v:Float ) :Float { return setTrait("fy",v); }
*/	
}
