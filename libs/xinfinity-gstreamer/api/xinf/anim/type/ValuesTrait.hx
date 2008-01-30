/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.TypedTrait;

class ValuesTrait extends TypedTrait<Array<String>> {

	public function new() {
		super( Array );
	}

    // FIXME: use an ereg to split. - [,\ \t\r\n]
    // maybe: remove quotes ['"], trim
    override public function parse( value:String ) :Dynamic {
        return value.split(";");
    }

	override public function getDefault() :Dynamic {
		return [""];
	}

}
