package xinf.traits;

class EnumTrait<T> extends TypedTrait<T> {

    var enumClass:Dynamic;
    var def:T;
	var sfx:String;
    
    public function new( enumClass:Dynamic, ?suffix:String, ?def:T ) {
        super();
        this.enumClass = enumClass;
        this.def = def;
		this.sfx = suffix;
		if( this.sfx==null ) this.sfx="";
    }
    
    override public function parse( value:String ) :Dynamic {
        for( choice in Type.getEnumConstructs(enumClass) ) {
            if( choice.toLowerCase() == value+sfx ) {
                var v = Reflect.field(enumClass,choice);
                return v;
            }
        }
        throw("Does not match an Enum value: '"+value+"'");
        return def;
    }

	override public function getDefault() :Dynamic {
		return def;
	}
	
}
