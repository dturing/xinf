/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

class Animate extends Animation {

	function value( t:Float ) :Float {
//		return from + ((to-from)*((t%dur)/dur));
		return t*50;
	}

	override function stop( t:Float ) {
		super.stop(t);
		if( fill==Fill.Freeze || fill==Fill.Hold )
			setOnTarget( value((t%simpleDuration)/simpleDuration) );
	}
	
	override function step( t:Float ) {
		var cur = value( (t%simpleDuration)/simpleDuration );
		
		trace("Anim, dur "+dur+", repeat "+repeatCount );
		trace("      "+from+"-"+to+" in "+dur );
		trace("      @"+t+": "+cur );
		
		setOnTarget(cur);
		
		super.step(t);
	}

	static function __init__() {
		var svgns = "http://www.w3.org/2000/svg"; //FIXME: smil?
	
        xinf.xml.Document.addToBinding( svgns, "animate", Animate );
        //xinf.xml.Document.addToBinding( svgns, "set", Set );
	}
}
