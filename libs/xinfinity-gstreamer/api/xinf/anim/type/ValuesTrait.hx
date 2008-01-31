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
		var a = new Array<String>();
		for( v in value.split(";") )
			a.push( StringTools.trim(v) );
        return a;
    }

	override public function getDefault() :Dynamic {
		return [""];
	}

}
