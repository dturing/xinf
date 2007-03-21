package xinf.style;

import xinf.erno.Color;

class Parser {
    static var globals:Hash<Dynamic>;

    static var split = ~/[ \r\n\t]*;[ \r\n\t]*/g;
    static var numeric = ~/^([0-9\.]+)$/;
    static var unit = ~/^([0-9\.]+)[\r\n\t ]*([a-zA-Z]+)$/;

    static var hexcolor = ~/^#([0-9a-f]+)$/i;

    static public function parseValue( name:String, value:String ) :Dynamic {
        if( globals==null ) {
            globals = new Hash<Dynamic>();
            globals.set( "black", Color.BLACK );
            globals.set( "white", Color.WHITE );
            globals.set( "none", Color.TRANSPARENT );    
        }
        
        var v:Dynamic;
        if( unit.match(value) ) {
            v = Std.parseFloat( unit.matched(1) );
            var u = unit.matched(2);
        //    trace("unit "+value+": "+v+"/"+u );
            
        } else if( numeric.match(value) ) {
            v = Std.parseFloat( numeric.matched(1) );
        //    trace("numeric "+value+": "+v );
            
        } else if( hexcolor.match(value) ) {
            var w = hexcolor.matched(1);
            if( w.length==3 ) {
                var c = Std.parseInt("0x"+w);
                var r = ((c&0xf00)>>8)/0xf;
                var g = ((c&0x0f0)>>4)/0xf;
                var b =  (c&0x00f)/0xf;
                v = new Color().fromRGB( r,g,b,1.0 );
            } else if( w.length==6 ) {
                v = new Color().fromRGBInt( Std.parseInt("0x"+w) );
            }
            
        } else if( (v=globals.get(value))!=null ) {
        //    trace("MATCH global: "+v+", "+value );
            
        } else {
        //    trace("no match: '"+value+"' in "+globals );
            v = value;
        }
        return v;
    }
    
    static public function parse( style:Style, text:String ) :Style {
        var properties = split.split(text); //text.split(";");
        for( prop in properties ) {
            var p = prop.split(":");
            if( p.length==2 ) {
                var name = StringTools.trim(p[0]);
                var value = StringTools.trim(p[1]);
                var v = parseValue( name, value );
                if( v!=null ) style.set( name, v );
            } else if( prop.length==0 ) {
            } else {
                throw("invalid CSS: '"+prop+"' in "+text );
            }
        }
        return style;
    }
}
