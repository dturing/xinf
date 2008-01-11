/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.IntList;

class IntListTrait extends TypedTrait<IntList> {

	public function new() {
		super( IntList );
	}

    // FIXME: use an ereg to split. - [,\ \t\r\n]
    // maybe: remove quotes ['"], trim
    override public function parse( value:String ) :Dynamic {
		if( value=="none" ) return null;
		var l = value.split(",");
		var l2 = new Array<Int>();
		for( i in l ) {
			l2.push( Std.parseInt(i) );
		}
        return new IntList( l2 );
    }

	override public function getDefault() :Dynamic {
		return null;
	}

}
