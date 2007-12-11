package xinf.style;

import xinf.traits.TraitAccess;
import xinf.traits.TraitException;

class StyleParser {

    static var split = ~/[ \r\n\t]*;[ \r\n\t]*/g;
    public static function parse( text:String, via:TraitAccess, to:Dynamic ) :Void {
        var properties = split.split(text);
        for( prop in properties ) {
            var p = prop.split(":");
            if( p.length==2 ) {
				var name = StringTools.trim(p[0]);
				var value = StringTools.trim(p[1]);
				try {
					via.setTraitFromString( name, value, to );
				} catch( e:TraitNotFoundException ) {
//					trace("ignore style property: "+name );
				}
            } else if( prop.length==0 ) {
            } else {
                throw("invalid CSS: '"+prop+"'" );
            }
        }
    }

}
