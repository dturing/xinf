/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class EnumTrait<T> extends TypedTrait<T> {

    var enumClass:Dynamic;
    var def:T;
	var sfx:String;
    
    public function new( enumClass:Dynamic, ?suffix:String, ?def:T ) {
        super(enumClass);
        this.enumClass = enumClass;
        this.def = def;
		this.sfx = suffix;
		if( this.sfx==null ) this.sfx="";
    }
    
    override public function parse( value:String ) :Dynamic {
		var v = value.toLowerCase();
        for( choice in Type.getEnumConstructs(enumClass) ) {
            if( choice.toLowerCase() == v+sfx ) {
                var v = Reflect.field(enumClass,choice);
                return v;
            }
        }
        throw("Value '"+value+"' not in "+Type.getEnumConstructs(enumClass));
        return def;
    }

	override public function write( value:Dynamic ) :String {
		var r = Std.string(value);
		if( sfx!=null ) r = r.substr(0,r.length-sfx.length);
		return r;
	}

	override public function getDefault() :Dynamic {
		return def;
	}
	
}
