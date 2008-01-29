/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;

class Set extends TimedAttributeSetter {
	
	static var TRAITS = {
		to: new StringTrait(),
	}

    public var to(get_to,set_to):String;
    function get_to() :String { return getTrait("to",String); }
    function set_to( v:String ) :String { setTrait("to",v); reschedule(); return v; }

	var oldValue:Dynamic;

	override function start() {
		super.start(); // FIXME: Set doesnt need to be stepped! as well as video probably...
		oldValue = getFromTarget();
		setOnTarget( to );
	}
	
	override function stop() {
		super.stop();
		if( fill!=Fill.Freeze && fill!=Fill.Hold )
			setOnTarget( oldValue );
	}

}