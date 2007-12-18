/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class FloatTrait extends TypedTrait<Float> {

    static var numeric = ~/^([\-+]?[0-9\.]+([eE][\-+]?[0-9]+)?)$/;
	
    var def:Float;
    
    public function new( ?def:Null<Float> ) {
		super();
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
	
	override public function getDefault() :Dynamic {
		return def;
	}
	
}
