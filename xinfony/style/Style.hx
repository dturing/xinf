package xinfony.style;

class Style {

    private var values :Hash<Dynamic>;

    public property color(get_color,set_color):Color;
    public property background(get_background,set_background):Color;
    public property border(get_border,set_border):Border;
    
    public function new( str:String ) {
        if( values != null ) throw("values != null");
        values = new Hash<Dynamic>();
        setFromString( StringTools.trim(str) );
    }
    
    public function get_color() :Dynamic {
        return _lookup( "color" );
    }
    public function set_color( v:Dynamic ) :Dynamic {
        var c = Color.fromDynamic(v);
        values.set( "color", c );
        return c;
    }
    public function get_background() :Dynamic {
        return _lookup( "background" );
    }
    public function set_background( v:Dynamic ) :Dynamic {
        var c = Color.fromDynamic(v);
        values.set( "background", c );
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
    
    
    public function _lookup( attr:String ) : Dynamic {
        // TODO: lookup in style chain.
        var r = values.get(attr);
        if( r == null ) throw("style attribute '"+attr+"' not specified.");
        return( r );
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
                    Reflect.callMethod( this, setter, [ value ] );
                }
            }
        }
    }
    
    public function toString() :String {
        var r:String="{\n";
        for( f in values.keys() ) {
            var field = values.get(f);
            r += "\t" + f + ": "+field+"\n";
        }
        r+="\t}";
        return r;
    }

    public static var DEFAULT = new Style("background: #eee; color: #000; border: 1px solid #000;");
    public static var INVERSE = new Style("background: #000; color: #fff; border: 1px solid #fff;");
    public static var HILITE = new Style("background: #ddd; color: #000; border: 1px solid #009;");
}
