/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import xinf.traits.TypedTrait;

class BorderTrait extends TypedTrait<Border> {

	static var whitespace = ~/\W/g;
	static var numeric = ~/^([0-9\.]+)$/;
	
	var def:Border;
	
	public function new( ?def:Border ) {
		super(Border);
		if( def==null ) def = new Border();
		this.def = def;
	}
	
	override public function parse( value:String ) :Dynamic {
		var vs = whitespace.split(value);
		var v = Lambda.array(Lambda.map( vs, Std.parseFloat ));
		if( v.length == 4 ) { // FIXME: some call_n magic?
			return new Border( v[0], v[1], v[2], v[3] );
		} else if( v.length == 2 ) {
			return new Border( v[0], v[1] );
		} else if( v.length == 1 ) {
			return new Border( v[0] );
		} else {
			return new Border();
		}
	}
	
	override public function getDefault() :Dynamic {
		return def;
	}

}
