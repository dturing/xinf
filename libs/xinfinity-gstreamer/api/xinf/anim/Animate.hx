/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.anim.type.Fill;

class Animate extends Animation {

	override function frozen( t:Float ) {
		if( (t-started)%simpleDuration==0 ) {
			// not modulo simpleDuration even if accumulate=None.
			setOnTarget( additiveValue(value(1.)) ); 
		} else {
			setOnTarget( aaValue(t) ); 
		}
	}
	
	override function step( t:Float ) {
		if( !super.step(t) ) return false;

		var cur = aaValue(t-started);
//		trace(""+peer+"."+attributeName+" @"+(Math.round(100*(t-started))/100)+": "+cur );
		setOnTarget(cur);
		
		return true;
	}

}
