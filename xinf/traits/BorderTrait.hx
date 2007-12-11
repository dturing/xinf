package xinf.traits;

class BorderTrait extends TypedTrait<Border> {

	static var whitespace = ~/\W/g;
	static var numeric = ~/^([0-9\.]+)$/;
	
	override public function parse( value:String ) :Dynamic {
		var vs = whitespace.split(value);
		var v = Lambda.array(Lambda.map( vs, Std.parseFloat ));
		if( v.length == 4 ) {
			return new Border( v[0], v[1], v[2], v[3] );
		} else if( v.length == 2 ) {
			return new Border( v[0], v[1], v[0], v[1] );
		} else if( v.length == 1 ) {
			return new Border( v[0], v[0], v[0], v[0] );
		} else {
			return new Border( 0, 0, 0, 0 );
		}
	}
	
	override public function getDefault() :Dynamic {
		return new Border(0,0,0,0);
	}

}
