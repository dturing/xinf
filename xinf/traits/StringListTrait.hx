package xinf.traits;

class StringListTrait extends TypedTrait<StringList> {

    override public function parseAndSet( value:String, style:Style ) {
        style.setTrait( name, parse(value) );
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
