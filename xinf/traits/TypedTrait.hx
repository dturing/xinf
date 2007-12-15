package xinf.traits;

class TypedTrait<T> implements TraitDefinition {
    
    public function new() {
    }

	/* actually, parse() should return T
	  but that fails in flash9 currently.
	  see http://lists.motion-twin.com/pipermail/haxe/2007-July/010658.html
	*/

    override public function parse( value:String ) :Dynamic {
		throw( "unimplemented" );
    }
	
	override public function getDefault() :Dynamic {
		throw( "unimplemented "+Type.getClassName(Type.getClass(this))+".getDefault()" );
		return null;
	}

}
