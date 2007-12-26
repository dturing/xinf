/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.StringList;

class StringListTrait extends TypedTrait<StringList> {

	public function new() {
		super( StringList );
	}

    // FIXME: use an ereg to split. - [,\ \t\r\n]
    // maybe: remove quotes ['"], trim
    override public function parse( value:String ) :Dynamic {
        return new StringList( value.split(",") );
    }

	override public function getDefault() :Dynamic {
		return new StringList( [""] );
	}

}
