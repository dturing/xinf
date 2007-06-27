
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
        if( Std.is( v, cl ) ) return v;
        return null;
    }

    public function getInheritedProperty<T>( name:String, cl:Dynamic ) :T {
        return getProperty(name,cl);
    }

    public function fromXml( xml:Xml ) :Void {
    }
    public function parse( values:String ) :Void {
    }
    
    
    public function getTextFormat() :xinf.erno.TextFormat {
        var family:String = getProperty("font-family",String);
        var size:Float = getProperty("font-size",Float);
        return xinf.erno.TextFormat.create( family, size );
    }
}
