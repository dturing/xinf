/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.anim.type.Fill;

class Animate extends Animation {

	static var eps = 0.0001; // FIXME not nice.
	
	override function frozen( t:Float ) {
		var o = t-started;
		var ofs = o % simpleDuration;
		var dist = Math.abs(simpleDuration-ofs);
		if( ofs<eps || dist<eps) {
			// not modulo simpleDuration even if accumulate=None.
			var cur = additiveValue(value(1.));
//			trace( "frozen at end, value "+cur );
			setOnTarget( cur ); 
		} else {
//			trace( "frozen with t offset "+ofs );
			setOnTarget( aaValue(o) ); 
		}
	}
	
	override function step( t:Float ) {
		if( !super.step(t) ) return false;

		var cur = aaValue(t-started);
	//	trace(""+peer+"."+attributeName+" @"+(Math.round(1000*(t-started))/1000)+": "+cur );
		setOnTarget(cur);
		
		return true;
	}

}
