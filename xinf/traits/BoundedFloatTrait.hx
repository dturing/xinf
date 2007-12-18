/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class BoundedFloatTrait extends FloatTrait {

    static var numeric = ~/^([0-9\.]+)$/;
    
	var min:Null<Float>;
	var max:Null<Float>;
	
    public function new( ?min:Null<Float>, ?max:Null<Float>, ?def:Null<Float> ) {
        super(def);
		this.min = min;
		this.max = max;
    }

	override public function parse( value:String ) :Dynamic {
		var v:Null<Float> = super.parse(value);

		if( min!=null ) v = Math.max( min, v );
		if( max!=null ) v = Math.min( max, v );

        return v;
    }
	
}
