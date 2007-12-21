/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class TypedTrait<T> implements TraitDefinition {
    
	var type:Dynamic;
	
    public function new( type:Dynamic ) {
		this.type=type;
    }

	/* actually, parse() should return T
	  but that fails in flash9 currently.
	  see http://lists.motion-twin.com/pipermail/haxe/2007-July/010658.html
	*/
    public function parse( value:String ) :Dynamic {
		throw( "unimplemented" );
    }
	
	public function fromDynamic( value:Dynamic ) :Dynamic {
		if( Std.is(value,type) ) {
			return value;
		}
		// by default, convert to string and parse
		return( parse( Std.string(value) ) );
	}
	
	public function getDefault() :Dynamic {
		throw( "unimplemented "+Type.getClassName(Type.getClass(this))+".getDefault()" );
		return null;
	}

}
