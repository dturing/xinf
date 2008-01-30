/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.StringTrait

class DynamicTrait extends TypedTrait<Dynamic> {

    public function new() {
        super(null);
    }

	override public function parse( value:String ) :Dynamic {
		return v;
    }
	
}
