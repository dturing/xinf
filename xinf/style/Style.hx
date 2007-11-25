
package xinf.style;

class Style {

	var style:Dynamic;
    
    public function new() {
        style = Reflect.empty();
    }
	
    public function setProperty<T>( name:String, value:T ) :T {
        Reflect.setField( style, name, value );
        return value;
    }

    public function getProperty<T>( name:String, cl:Dynamic ) :T {
        var v:Dynamic = Reflect.field( style, name );
        if( Std.is( v, cl ) ) {
			return v;
		}
        return null;
    }

    public function getInheritedProperty<T>( name:String, cl:Dynamic ) :T {
        return getProperty(name,cl);
    }

    public function fromXml( xml:Xml ) :Void {
		throw("unimplemented");
    }
    public function fromObject( obj:Dynamic ) :Void {
		throw("unimplemented");
    }
    public function parse( values:String ) :Void {
		throw("unimplemented parse "+values);
    }
	public function getDefault<T>( name:String ) :T {
		return null;
	}
	
    public function getTextFormat() :xinf.erno.TextFormat {
        var family:String = ""+getInheritedProperty("font-family",StringList);
        var size:Float = getInheritedProperty("font-size",Float);
		// TODO: weight
        return xinf.erno.TextFormat.create( family, size );
    }
	
	public function toString() :String {
		var r = "{";
		for( field in Reflect.fields(style) ) {
			r += "\n\t\t"+field+": "+Reflect.field(style,field);
		}
		r+="\n\t}";
		
		return r;
	}
	
}
