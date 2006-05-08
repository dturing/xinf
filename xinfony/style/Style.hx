package xinfony.style;

import xinfony.style.Color;

class Style {
    private var values :Hash<Dynamic>;

    public property color(default,default):Color;
    public property backgroundColor(get_backgroundColor,set_backgroundColor):Dynamic;
    public property border(default,default):Int;
    public property borderColor(default,default):Color;
    
    public function get_backgroundColor() :Dynamic {
        return values.get( "backgroundColor" );
    }
    public function set_backgroundColor( v:Dynamic ) :Dynamic {
        values.set( "backgroundColor", Color.fromDynamic(v) );
        return c;
    }
    
    public function new( str:String ) {
        values = new Hash<Dynamic>();
        
        color = Color.rgb(0,0,0);
        backgroundColor = Color.rgb(0xff,0xff,0xff);
        border = 1;
        borderColor = Color.rgb(0,0,0);

        setFromString( StringTools.trim(str) );
    }
    
    public function setFromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = StringTools.trim(a[0]);
                var value = StringTools.trim(a[1]);
                trace("Style assignment: "+name+" = "+value );
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
