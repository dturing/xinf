/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

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
//            trace("glyph "+character+" not cached in "+this+" (yet)");
        
            g = new TextureGlyph( character, font, size, hint );
            glyphs.set(character,g);
        }
        return g;
    }
    
    public function toString() :String {
        return("Cache("+font+","+size+")");
    }
}
