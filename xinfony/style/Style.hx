package xinfony.style;

class Style {
    private var values :Hash<Dynamic>;

    public property color(get_color,set_color):Color;
    public property backgroundColor(get_backgroundColor,set_backgroundColor):Dynamic;
    public property border(get_border,set_border):Border;
    
    public function get_color() :Dynamic {
        return _lookup( "color" );
    }
    public function set_color( v:Dynamic ) :Dynamic {
        var c = Color.fromDynamic(v);
        values.set( "color", c );
        return c;
    }
    public function get_backgroundColor() :Dynamic {
        return _lookup( "backgroundColor" );
    }
    public function set_backgroundColor( v:Dynamic ) :Dynamic {
        var c = Color.fromDynamic(v);
        values.set( "backgroundColor", c );
        return c;
    }
    public function get_border() :Dynamic {
        return _lookup( "border" );
    }
    public function set_border( v:Dynamic ) :Dynamic {
        var c = Border.fromDynamic(v);
        values.set( "border", c );
        return c;
    }
    
    public function new( str:String ) {
        values = new Hash<Dynamic>();
        
        color = Color.BLACK;
        backgroundColor = Color.WHITE;
        border = Border.BLACK_1PX;

        setFromString( StringTools.trim(str) );
    }
    
    
    public function _lookup( attr:String ) : Dynamic {
        // TODO: lookup in style chain.
        return( values.get(attr) );
    }
    
    
    public function setFromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = StringTools.trim(a[0]);
                var value = StringTools.trim(a[1]);
                var setter = Reflect.field( this, "set_"+name );
                if( !setter ) {
                    trace("Unknown style attribute: "+name+" (ignored)" );
                } else {
                    setter( value );
                }
            }
        }
    }
    
    public function toString() :String {
        var r:String="";
        for( f in values.keys() ) {
            var field = values.get(f);
            r += "\t" + f + ": "+field+"\n";
        }
        return r;
    }
}
