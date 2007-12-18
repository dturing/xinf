/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class BoolTrait extends TypedTrait<Bool> {

    var def:Bool;
    
    public function new( ?def:Null<Bool> ) {
		super();
		if( def==null ) def=false;
        this.def = def;
    }

	override public function parse( value:String ) :Dynamic {
        var v = false;

		if( value=="1" || value=="on" || value=="yes" ) {
			v=true;
        } 

        return v;
    }
	
	override public function getDefault() :Dynamic {
		return def;
	}
	
}
