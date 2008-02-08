/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.anim.type.Fill;

class AnimateTransform extends Animate {

	static var TRAITS = {
		type: new StringTrait(),
	};

    public var type(get_type,set_type):String;
    function get_type() :String { return getStyleTrait("type",String); }
    function set_type( v:String ) :String { setStyleTrait("type",v); reschedule(); return v; }

	override function fromDynamic( value:Dynamic ) :Dynamic {
		var s = type+"("+value+")";
//		trace("AnimateTransform: "+s );
		return targetDefinition.fromDynamic( s );
	}

	static function __init__() {
		var svgns = "http://www.w3.org/2000/svg"; //FIXME: smil?
	
        xinf.xml.Document.addToBinding( svgns, "animate", Animate );
        xinf.xml.Document.addToBinding( svgns, "animateColor", Animate );
        xinf.xml.Document.addToBinding( svgns, "animateTransform", AnimateTransform );
        xinf.xml.Document.addToBinding( svgns, "animateMotion", AnimateMotion );
        xinf.xml.Document.addToBinding( svgns, "mpath", MPath );
        xinf.xml.Document.addToBinding( svgns, "set", Set );
        xinf.xml.Document.addToBinding( svgns, "par", ParallelTimeContainer );
	}
}
