/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

class Animate extends Animation {

	override function stop( t:Float ) {
		super.stop(t);
		/*
		if( fill==Fill.Freeze || fill==Fill.Hold ) {
			if( t%simpleDuration==0 ) 
				setOnTarget( animationFunction(1.) );
			else
				setOnTarget( animationFunction((t%simpleDuration)/simpleDuration) );
		}
		*/
	}
	
	override function step( t:Float ) {
		if( !super.step(t) ) return false;

		var cur = aaValue(t);
		trace("      @"+t+": "+cur );
		setOnTarget(cur);
		
		return true;
	}

	static function __init__() {
		var svgns = "http://www.w3.org/2000/svg"; //FIXME: smil?
	
        xinf.xml.Document.addToBinding( svgns, "animate", Animate );
        //xinf.xml.Document.addToBinding( svgns, "set", Set );
	}
}
