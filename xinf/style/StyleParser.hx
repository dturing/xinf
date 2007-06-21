package xinf.style;

import xinf.erno.Color;

class StyleParser {

    static var split = ~/[ \r\n\t]*;[ \r\n\t]*/g;
    public static function parse( text:String, s:Style, defs:Hash<StylePropertyDefinition> ) :Void {
        var properties = split.split(text); //text.split(";");
        for( prop in properties ) {
            var p = prop.split(":");
            if( p.length==2 ) {
                var name = StringTools.trim(p[0]);
                var value = StringTools.trim(p[1]);
                
                var def:StylePropertyDefinition = defs.get(name);
                if( def!=null ) {
                    def.parseAndSet( value, s );
                } else {
                    trace("unknown style property '"+name+"'" );
                }
            } else if( prop.length==0 ) {
            } else {
                throw("invalid CSS: '"+prop+"'" );
            }
        }
    }

    public static function parseXmlAttributes( xml:Xml, s:Style, defs:Hash<StylePropertyDefinition> ) :Void {
        for( attr in xml.attributes() ) {
            var def = defs.get(attr);
            if( def!=null ) {
                def.parseAndSet( xml.get(attr), s );
            }
        }
    }
}
