/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

import xinf.type.Length;

class LengthTrait extends TypedTrait<Length> {

    var def:Length;
    
    public function new( ?def:Null<Length> ) {
		super();
		if( def==null ) def = new Length(0);
        this.def = def;
    }

	override public function parse( value:String ) :Dynamic {
		return new Length(value);
    }
	
	override public function getDefault() :Dynamic {
		return def;
	}
	
}
