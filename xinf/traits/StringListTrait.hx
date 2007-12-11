package xinf.traits;

import xinf.type.StringList;

class StringListTrait extends TypedTrait<StringList> {
	
    // FIXME: use an ereg to split. - [,\ \t\r\n]
    // maybe: remove quotes ['"], trim
    override public function parse( value:String ) :Dynamic {
        return new StringList( value.split(",") );
    }

	override public function getDefault() :Dynamic {
		return new StringList( [""] );
	}

}
