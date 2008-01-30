/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.FloatTrait;

class DurationTrait extends FloatTrait {

    public function new() {
        super(-1);
    }

	override public function parse( value:String ) :Dynamic {
		if( value=="indefinite" || value=="media" ) return -1.;
		var v:Null<Float> = TimeTrait.parseClockValue(value);
		if( v<0 ) throw("duration needs to be positive");
        return v;
    }
	
}
