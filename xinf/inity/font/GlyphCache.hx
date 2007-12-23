/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity.font;

class GlyphCache {
    var glyphs:IntHash<Glyph>;
    var size:Int;
    var font:Font;
    var hint:Bool;
    
    public function new( font:Font, size:Int, ?hint:Bool ) {
        glyphs = new IntHash<Glyph>();
        this.font = font;
        this.size = size;
        if( hint==null ) hint=false; 
        this.hint = hint;
    }
    
    public function get( character:Int ) {
        var g = glyphs.get(character);
        if( g==null ) {
//			trace("caching glyph "+character );
			try {
				g = new TextureGlyph( character, font, size, hint );
				glyphs.set(character,g);
			} catch(e:Dynamic) {
				trace(""+e+": "+character);
			}
        }
        return g;
    }
    
    public function toString() :String {
        return("Cache("+font+","+size+")");
    }
}
