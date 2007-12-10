package xinf.traits;

class StringTrait extends TypedTrait<String> {

    override public function parseAndSet( value:String, obj:TraitAccess ) {
        obj.setTrait( name, parse(value) );
    }

	public function parse( value:String ) :String {
        return StringTools.trim(value);
    }

	override public function getDefault() :Dynamic {
		return "";
	}

}
