/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.FloatTrait;

class LineIncrementTrait extends FloatTrait {

    public function new() {
        super(-1);
    }

	override public function parse( value:String ) :Dynamic {
		if( value=="auto" ) return -1.;
		
		var v:Null<Float> = super.parse(value);
		if( v<0 ) throw("line-increment needs to be positive");
        return v;
    }
	
}
