package xinfony;

import xinfony.Color;

class Colors {
    public static function toInt( c : Color ) : Int {
        return switch( c ) {
            case rgb(r,g,b): ( r << 16 ) | ( g << 8 ) | b;
            case int(c): c;
        }
    }
    public static function toString( c : Color ) : String {
        return switch( c ) {
            case rgb(r,g,b): "rgb("+r+","+g+","+b+")";
            case int(c): "rgb("+(c>>16)+","+((c>>8)&0xff)+","+(c&0xff)+")";
        }
    }
}
