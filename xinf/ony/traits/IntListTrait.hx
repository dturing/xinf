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

	override public function write( value:Dynamic ) :String {
		return value.join(",");
	}

	override public function interpolate( _a:Dynamic, _b:Dynamic, f:Float ) :Dynamic {
		var a:Array<Int> = cast(_a).list;
		var b:Array<Int> = cast(_b).list;
		if( a.length != b.length ) return a;
		
		var r = new Array<Int>();
		for( i in 0...a.length ) {
			r.push( Math.round(a[i] + ((b[i]-a[i])*f)) );
		}
		return new IntList(r);
	}
	
	override public function distance( _a:Dynamic, _b:Dynamic ) :Float {
		var a:Array<Int> = cast(_a).list;
		var b:Array<Int> = cast(_b).list;
		if( a.length != b.length ) return 1.;
		var r=0;
		for( i in 0...a.length ) {
			r+=Math.round(Math.abs(b[i]-a[i]));
		}
		return r;
	}
	
	override public function getDefault() :Dynamic {
		return null;
	}

}
