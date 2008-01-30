/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.FloatTrait;

class RepeatTrait extends FloatTrait {

    public function new() {
        super(1.);
    }

	override public function parse( value:String ) :Dynamic {
		if( value=="indefinite" ) return Math.POSITIVE_INFINITY;
		var v:Null<Float> = super.parse(value);
		if( v<0 ) throw("repetition needs to be positive");
        return v;
    }
	
}
