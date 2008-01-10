/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class FloatTrait extends TypedTrait<Float> {

    static var numeric = ~/^([\-+]?[0-9\.]+([eE][\-+]?[0-9]+)?)$/;
	
    var def:Float;
    
    public function new( ?def:Null<Float> ) {
		super( Float );
		if( def==null ) def=0.;
        this.def = def;
    }

	override public function parse( value:String ) :Dynamic {
        var v:Null<Float> = null;

		if( numeric.match(value) ) {
            v = Std.parseFloat( numeric.matched(1) );
        }

        if( v==null ) throw("Not a numeric/unit value: "+value );

        return v;
    }

	override public function fromDynamic( value:Dynamic ) :Dynamic {
		if( Std.is(value,Int) ) {
			return (value*1.);
		}
		return( super.fromDynamic(value) );
	}

	override public function getDefault() :Dynamic {
		return def;
	}
	
}
