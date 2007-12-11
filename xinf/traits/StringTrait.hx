package xinf.traits;

class StringTrait extends TypedTrait<String> {

	override public function parse( value:String ) :Dynamic {
        return StringTools.trim(value);
    }

	override public function getDefault() :Dynamic {
		return null;
	}

}
