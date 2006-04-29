package org.xinf.display;

import org.xinf.display.primitive.Polygon;
import org.xinf.display.primitive.Contour;
import org.xinf.geom.Point;

class Glyph {
    private var polygon:Polygon;
    private var advance:Float;
    private var list:Int;
    
    public function new( p:Polygon, adv:Float ) {
        polygon = p;
        advance = adv;
        list = 0;
    }
    
    public function _cache( r:org.xinf.render.IRenderer ) {
        list = r.genList();
        r.newList( list );
            polygon._render( r );
            r.translate( advance, .0 );
        r.endList();
    }

    public function _render( r:org.xinf.render.IRenderer ) {
        r.callList( list );
    }
}

class Font {
    private var glyphs:Array<Glyph>;
    
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
        scale = .0000025;
        
        var _f = FT.LoadFont( untyped name.__s, untyped "abcdefghijklmnopqrstuvwxyz".__s, 1024<<6, 1024<<6 );
       
        for( field in Reflect.fields(_f) ) {
            trace("font->"+field + ": " + untyped __dollar__objget( _f, __dollar__hash(field.__s) ) );
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
        contour = new Contour(scale*x,scale*y);
    }

    private function endContour() {
        polygon.addContour( contour );
        contour = null;
    }

    private function lineTo( x:Int, y:Int ) {
        contour.addCoordinates( scale*x, scale*y );
    }

    private function curveTo( cx:Int, cy:Int, x:Int, y:Int ) {
        contour.addQuadratic( new Point(scale*cx,scale*cy), new Point(scale*x,scale*y) );
    }
}
