/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class StringTrait extends TypedTrait<String> {

	var def:String;
	
	public function new( ?def:String ) {
		super( String );
		this.def=def;
	}

	override public function parse( value:String ) :Dynamic {
        return StringTools.trim(value);
    }

	override public function getDefault() :Dynamic {
		return def;
	}

}
