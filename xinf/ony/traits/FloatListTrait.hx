/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.FloatList;

class FloatListTrait extends TypedTrait<FloatList> {

	public function new() {
		super( FloatList );
	}

	// FIXME: use an ereg to split. - [,\ \t\r\n]
	// maybe: remove quotes ['"], trim
	override public function parse( value:String ) :Dynamic {
		if( value=="none" ) return null;
		var l = value.split(",");
		var l2 = new Array<Float>();
		for( i in l ) {
			l2.push( Std.parseFloat(i) );
		}
		return new FloatList( l2 );
	}

	override public function write( value:Dynamic ) :String {
		return value.join(",");
	}

	override public function getDefault() :Dynamic {
		return null;
	}

}
