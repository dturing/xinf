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

import xinf.inity.GLPolygon;
typedef Polygon = GLPolygon

class FontReader {
	
    private var font:Font;
    private var glyph:Glyph;
    private var polygon:Polygon;
    private var scale:Float;

    public function new( ttfData:String ) {
        font = new Font();
        polygon = new Polygon();
        
        var _font = new fonttools.Font( ttfData, 1024<<6, 1024<<6 );
		
		// FIXME: move this to fonttools
		var _f = untyped _font.__f;
        scale = 1./(1024<<6);
//        trace("Font Height: "+_f.height );
  
        for( field in [ 
            "family_name", "style_name", "file_name"
            ] ) {
            var h = untyped __dollar__hash(field.__s);
            untyped __dollar__objset( font, h, untyped __dollar__objget( _f, h ) );
        }

        for( field in [ 
            "underline_thickness", "underline_position", 
            "height", "ascender", "descender", "units_per_EM"
            ] ) {
            var h = untyped __dollar__hash(field.__s);
			untyped __dollar__objset( font, h, untyped __dollar__objget( _f, h ) / _f.units_per_EM );
        }
        
        _font.iterateAllGlyphs( this );
        
    }
    
    public function getFont() : Font {
        return font;
    }
    
    private function _add_glyph( character:Int, g:Glyph ) {
        if( character > 0 && character < 0xff ) {
            untyped font.glyphs.__a[character] = g;
        } else {
            // non-ascii chars currently ignored
        }
    }

    public function endGlyph( character:Int, advance:Int ) {
        var g:Glyph = new Glyph( polygon, scale*advance );
		_add_glyph( character, g );
        polygon = new Polygon();
	}

    public function startContour( x:Int, y:Int ) {
		polygon.startPath(scale*x,-scale*y);
    }

    public function endContour() {
		polygon.endPath();
    }

    public function lineTo( x:Int, y:Int ) {
		polygon.lineTo( scale*x, -scale*y );
    }

    public function curveTo( cx:Int, cy:Int, x:Int, y:Int ) {
		polygon.quadraticTo( scale*cx,-scale*cy, scale*x,-scale*y );
    }
    
}
