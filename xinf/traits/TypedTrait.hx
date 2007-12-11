package xinf.traits;

class TypedTrait<T> implements TraitDefinition {
    
    public function new() {
    }

	/* actually, this class should implement parse() for descendants to override
	  but that fails in flash9 currently.
	  see http://lists.motion-twin.com/pipermail/haxe/2007-July/010658.html
	*/

    override public function parseAndSet( name:String, value:String, obj:TraitAccess ) {
		throw( "unimplemented" );
    }
	
	override public function getDefault() :Dynamic {
		throw( "unimplemented" );
		return null;
	}

}
