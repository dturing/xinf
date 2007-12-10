package xinf.traits;

class FloatTrait extends TypedTrait<Float> {

    static var numeric = ~/^([0-9\.]+)$/;

    var def:Float;
    
    public function new( name:String, ?def:Null<Float> ) {
        super(name);
        this.def = def;
		if( def==null ) this.def=0.;
    }

    override public function parseAndSet( value:String, obj:TraitAccess ) {
        obj.setTrait( name, parse(value) );
    }

	public function parse( value:String ) :Float {
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
