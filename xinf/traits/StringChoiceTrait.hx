package xinf.traits;

class StringChoiceTrait extends TypedTrait<String> {

    var choices:Array<String>;
    
    public function new( name:String, choices:Array<String> ) {
        super(name);
        this.choices=choices;
    }
    
    override public function parseAndSet( value:String, style:Style ) {
        style.setTrait( name, parse(value) );
    }

	public function parse( value:String ) :String {
        for( choice in choices ) {
            if( choice==value ) return choice;
        }
        return null;
    }

	override public function getDefault() :Dynamic {
		return choices[0];
	}

}
