package xinf.traits;

import xinf.type.StringList;

class StringListTrait extends TypedTrait<StringList> {

    override public function parseAndSet( name:String, value:String, obj:TraitAccess ) {
        obj.setTrait( name, parse(value) );
    }
	
    // FIXME: use an ereg to split. - [,\ \t\r\n]
    // maybe: remove quotes ['"], trim
    public function parse( value:String ) :StringList {
        return new StringList( value.split(",") );
    }

	override public function getDefault() :Dynamic {
		return new StringList( [""] );
	}

}
