/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;
import xinf.anim.type.Fill;

class Set extends TimedAttributeSetter {
	
	static var TRAITS = {
		to: new StringTrait(),
	}

    public var to(get_to,set_to):String;
    function get_to() :String { return getTrait("to",String); }
    function set_to( v:String ) :String { setTrait("to",v); return v; }

	var oldValue:Dynamic;

	override function start(t:Float) {
		super.start(t); // FIXME: Set doesnt need to be stepped! as well as video probably...
		setOnTarget( to );
	}
	
	override function stop(t:Float) {
		super.stop(t);
		if( fill!=Fill.Freeze && fill!=Fill.Hold )
			resetOnTarget();
	}

}
