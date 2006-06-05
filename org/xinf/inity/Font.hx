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

package org.xinf.inity;

import org.xinf.inity.Polygon;
import org.xinf.inity.Contour;
import org.xinf.geom.Point;

class Glyph {
    private var polygon:Polygon;
    public var advance:Float;
    private var list:Int;
    
    public function new( p:Polygon, adv:Float ) {
        polygon = p;
        advance = adv;
        list = 0;
    }
    
    public function render() {
        polygon.render();
        GL.Translatef( advance, .0, .0 );
    }
}

class Font {
    private static var fonts:Hash<Font> = new Hash<Font>();
    public static function getFont( name:String ) {
        var font:Font;
        font = fonts.get(name);
        if( font != null ) return font;
        
        font = new FontReader("/home/dan/.fonts/vera.ttf").getFont();
        fonts.set( name, font );
        return font;
    }

    private var glyphs:Array<Glyph>;
    
    public var family_name(default,null):String;
    public var style_name(default,null):String;
    public var ascender(default,null):Float;
    public var descender(default,null):Float;
    public var height(default,null):Float;
    public var underline_thickness(default,null):Float;
    public var underline_position(default,null):Float;
    public var units_per_EM(default,null):Float;
    
    public function new() {
        glyphs = new Array<Glyph>();
        untyped glyphs.__resize(0xff);
    }
    
    public function getGlyph( character:Int ):Glyph {
        var g:Glyph = glyphs[character];
        return( g );
    }
}

class FontReader {
    private var font:Font;
    private var glyph:Glyph;
    private var contour:Contour;
    private var polygon:Polygon;
    private var scale:Float;

    public function new( name:String ) {
        font = new Font();
        polygon = new Polygon();
        
        var _f = FT.LoadFont( untyped name.__s, untyped "abcdefghijklmnopqrstuvwxyz".__s, 1024<<6, 1024<<6 );
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
        
        FT.IterateGlyphs( _f, this );
        
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

    private function endGlyph( character:Int, advance:Int ) {
        var g:Glyph = new Glyph( polygon, scale*advance );
        _add_glyph( character, g );
        polygon = new Polygon();
        contour = null;
    }

    private function startContour( x:Int, y:Int ) {
        contour = new Contour(scale*x,-scale*y);
    }

    private function endContour() {
        polygon.addContour( contour );
        contour = null;
    }

    private function lineTo( x:Int, y:Int ) {
        contour.addCoordinates( scale*x, -scale*y );
    }

    private function curveTo( cx:Int, cy:Int, x:Int, y:Int ) {
        contour.addQuadratic( new Point(scale*cx,-scale*cy), new Point(scale*x,-scale*y) );
    }
}
