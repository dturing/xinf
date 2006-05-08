package xinfony.style;

class Color {
    public var r:Int;
    public var g:Int;
    public var b:Int;
    public var a:Int;
    
    public function new( _r:Int, _g:Int, _b:Int, _a:Int ) {
        r=_r; g=_g; b=_b; a=_a;
    }
        
    public static var BLACK:Color = rgb(0,0,0);
    public static var NIL:Color = rgba(0,0,0,0);
    public static var WHITE:Color = rgb(0xff,0xff,0xff);
        
    public static function rgb( r:Int, g:Int, b:Int ) {
        return( new Color(r,g,b,0xff) );
    }

    public static function rgba( r:Int, g:Int, b:Int, a:Int ) {
        return( new Color(r,g,b,a) );
    }
    
    public static function fromInt( c:Int ) {
        return( new Color( c>>16, (c>>8) & 0xff, c & 0xff, 0xff ) );
    }

    public static function fromDynamic( v:Dynamic ) :Color {
        switch( Reflect.typeof(v) ) {
            case TObject:
                if( Std.is(v,Color) ) {
                    return cast(v,Color);
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    throw("Cannot parse Color from "+Reflect.getClass(v).__name__.join(".")+": "+v );
                }
            default:
                throw("Cannot parse Color from "+Reflect.typeof(v)+": "+v );
        }
        return( Color.NIL );
    }
    
    public static function fromString( v:String ) :Color {
        var t:Color;
        if( StringTools.startsWith(v,"#") ) {
            var s = v.substr(1,v.length);
            if( s.length == 3 ) {
                var i = Std.parseInt("0x"+s);
                return( Color.rgb( 
                    ((i>>4)&0xf0) | ((i>>8)&0xf), 
                    ((i)&0xf0) | ((i>>4)&0xf), 
                    ((i<<4)&0xf0) | ((i)&0xf) ) );
            } else if( s.length == 6 ) {
                var i = Std.parseInt("0x"+s);
                return( Color.fromInt( i ) );
            } else {
                throw("Cannot parse Color "+v );
            }
        } else if( StringTools.startsWith(v,"rgb(") ) {
            var s = v.substr(5,v.length-6).split(",");
            if( s.length != 3 ) throw( "Cannot parse color "+v );
            var c = new Array<Int>();
            for( i in 0...3 ) {
                c.push( Std.parseInt( s[i] ) );
            }
            trace( c );
            return( Color.rgb( c.shift(), c.shift(), c.shift() ) );
        } else if( (t = predefined.get(v)) != null ) {
            return( t );
        } else {
            throw("Cannot parse Color "+v );
        }
        
        return Color.NIL;
    }
    
    public function toString() :String {
        return("rgba("+r+","+g+","+b+","+a+")");
    }
    
    public static var predefined:Hash<Color> = _genPredefined();
    public static function _genPredefined() :Hash<Color> {
        var p:Hash<Color> = new Hash<Color>();
        p.set("black",Color.BLACK);
        p.set("white",Color.WHITE);
        /* TODO: more, more! */
        return p;
    }
}
