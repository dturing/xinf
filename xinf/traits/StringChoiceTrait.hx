/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class StringChoiceTrait extends TypedTrait<String> {

    var choices:Array<String>;
    
    public function new( choices:Array<String> ) {
		super();
        this.choices=choices;
    }
    
	override public function parse( value:String ) :Dynamic {
        for( choice in choices ) {
            if( choice==value ) return choice;
        }
        return null;
    }

	override public function getDefault() :Dynamic {
		return choices[0];
	}

}
