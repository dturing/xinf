package xinf.traits;

class StringChoiceTrait extends TypedTrait<String> {

    var choices:Array<String>;
    
    public function new( choices:Array<String> ) {
		super();
        this.choices=choices;
    }
    
    override public function parseAndSet( name:String, value:String, obj:TraitAccess ) {
        obj.setTrait( name, parse(value) );
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
