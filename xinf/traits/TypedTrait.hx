package xinf.traits;

class TypedTrait<T> implements TraitDefinition {

    public var name:String;
    
    public function new( name:String ) {
        this.name=name;
    }

	/* actually, this class should implement parse() for descendants to override
	  but that fails in flash9 currently.
	  see http://lists.motion-twin.com/pipermail/haxe/2007-July/010658.html
	*/

    override public function parseAndSet( value:String, obj:TraitAccess ) {
		throw( "unimplemented" );
    }
	
	override public function getDefault() :Dynamic {
		throw( "unimplemented" );
		return null;
	}

}
