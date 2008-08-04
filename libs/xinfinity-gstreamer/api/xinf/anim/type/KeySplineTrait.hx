/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.TypedTrait;

class KeySplineTrait extends TypedTrait<KeySplines> {

	public function new() {
		super( KeySplines );
	}

	override public function parse( value:String ) :Dynamic {
		var ks = new KeySplines();
		var defs = value.split(";"); // FIXME: use ereg, whitespace
		for( def in defs ) {
			var pts = StringTools.trim(def).split(" ");
			if( pts.length!=4 ) throw("Invalid KeySplines: '"+value+"'");
			ks.list.push( new KeySpline(
				Std.parseFloat(pts[0]),
				Std.parseFloat(pts[1]),
				Std.parseFloat(pts[2]),
				Std.parseFloat(pts[3]) ));
		}
		return ks;
	}
	
	override public function getDefault() :Dynamic {
		return null;
	}

}
