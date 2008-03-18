/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.geom.Types;

class PointListTrait extends TypedTrait<Iterable<TPoint>> {

	public function new() {
		super( new List<TPoint>() );
	}

	static var pointSplit = ~/[ ,]+/g;
    override public function parse( value:String ) :Dynamic {
        var ps = new List<TPoint>();
        var s = pointSplit.split( value );

		// odd number of coordinates - invalid, shall not be rendered.
		if( s.length % 2 != 0 ) return ps;

        while( s.length>1 ) {
            var x = Std.parseFloat( s.shift() );
            var y = Std.parseFloat( s.shift() );
            ps.add( {x:x, y:y} );
        }
        
        return ps;
    }

	override public function write( value:Dynamic ) :String {
		var r="";
		var v:Iterable<TPoint> = cast(value);
		for( p in v ) {
			r+=p.x+","+p.y+" ";
		}
		return r;
	}
	
	override public function getDefault() :Dynamic {
		return new List<TPoint>();
	}

}
