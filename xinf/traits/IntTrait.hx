package xinf.traits;

class IntTrait extends TypedTrait<Int> {

    static var numeric = ~/^([0-9\.]+)$/;

    var def:Int;
    
    public function new( ?def:Null<Int> ) {
		super();
		if( def==null ) def=0;
        this.def = def;
    }

	override public function parse( value:String ) :Dynamic {
        var v:Null<Int> = null;

		if( numeric.match(value) ) {
            v = Std.parseInt( numeric.matched(1) );
        }

        if( v==null ) throw("Not an integer value: "+value );

        return v;
    }
	
	override public function getDefault() :Dynamic {
		return def;
	}
	
}
