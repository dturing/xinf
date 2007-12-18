/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

// FIXME: regard unit!
class UnitFloatTrait extends FloatTrait {

    static var numeric = ~/^([0-9\.]+)$/;
    static var unit = ~/^([0-9\.]+)[\r\n\t ]*([a-zA-Z]+)$/;

	override public function parse( value:String ) :Dynamic {
        var v:Null<Float> = null;

        if( unit.match(value) ) {
            v = Std.parseFloat( unit.matched(1) );
            var u = unit.matched(2);
            // FIXME. unit not yet taken into account
        } else if( numeric.match(value) ) {
            v = Std.parseFloat( numeric.matched(1) );
        }

        if( v==null ) throw("Not a numeric/unit value: "+value );

        return v;
    }

}
