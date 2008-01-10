/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.Length;

class LengthTrait extends TypedTrait<Length> {

    var def:Length;
    
    public function new( ?def:Null<Length> ) {
		super( Length );
		if( def==null ) def = new Length(0);
        this.def = def;
    }

	override public function parse( value:String ) :Dynamic {
		return new Length(value,null);
    }

	override public function fromDynamic( value:Dynamic ) :Dynamic {
		if( Std.is(value,Float) ) {
			return new Length(null,value);
		}
		return super.fromDynamic(value);
	}

	override public function getDefault() :Dynamic {
		return def;
	}
	
}
