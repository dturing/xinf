
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

    public function getProperty<T>( name:String, cl:Class<T> ) :T {
        var v:Dynamic = Reflect.field( style, name );
        if( Std.is( v, cl ) ) return v;
        return null;
    }
    
    public function fromXml( xml:Xml ) :Void {
    }
    
    public function parseXmlProperties( xml:Xml, properties:Iterable<String> ) :Void {
        for( prop in properties ) {
            if( xml.exists(prop) ) {
                setProperty( prop, StyleParser.parseValue(xml.get(prop)) );
            }
        }
    }
}
