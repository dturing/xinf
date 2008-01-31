/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.anim.type.Fill;

class Animate extends Animation {

	override function stop( t:Float ) {
		super.stop(t);
		
		if( fill==Fill.Freeze || fill==Fill.Hold ) {
			if( (t-started)%simpleDuration==0 ) {
				// not modulo simpleDuration even if accumulate=None.
				var freezeVal = additiveValue(value(.99999999999999)); // FIXME: nerv.
				setOnTarget( freezeVal ); 
			}
		} else {
			resetIteration(t);
		}
		
	}
	
	override function step( t:Float ) {
		if( !super.step(t) ) return false;

		var cur = aaValue(t-started);
		trace(""+peer+"."+attributeName+" @"+(Math.round(100*(t-started))/100)+": "+cur );
		setOnTarget(cur);
		
		return true;
	}

	static function __init__() {
		var svgns = "http://www.w3.org/2000/svg"; //FIXME: smil?
	
        xinf.xml.Document.addToBinding( svgns, "animate", Animate );
        xinf.xml.Document.addToBinding( svgns, "animateColor", Animate );
        xinf.xml.Document.addToBinding( svgns, "set", Set );
        xinf.xml.Document.addToBinding( svgns, "par", ParallelTimeContainer );
	}
}
