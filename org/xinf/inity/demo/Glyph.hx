package org.xinf.inity.demo;

import org.xinf.inity.Font;
import org.xinf.inity.Object;

class Glyph extends Object {
    private static var _font:Font = new FontReader("/home/dan/.fonts/vera.ttf").getFont();
    private var glyph:Int;

    public function new() {
        super();
        glyph = 65;
    }
    
    public function setGlyph( g:Int ) {
        glyph = g;
        changed();
    }
        
    private function renderLine( x1:Float, y1:Float, x2:Float, y2:Float ) {
        GL.Begin( GL.LINES );
            GL.Vertex3f( x1, y1, 0 );
            GL.Vertex3f( x2, y2, 0 );
        GL.End();
    }
    
    private function _renderGraphics() :Void {
        var lineHeight:Float = (_font.ascender + _font.descender + _font.height)*50;

        var g = _font.getGlyph( glyph );
        var w = g.advance;
        var b = 0.1;

        GL.Translatef( -.5, -.5, 1.0 );
        GL.Scalef( 124., 124., 1.0 );

      // text
        GL.PushMatrix();
        GL.Color4f( 1., 1., 1., .5 );
        g.render();
        GL.PopMatrix();
        
      // metrics lines
        GL.Color4f( 1., 1., 1., 1. );
        GL.LineWidth( 1 );
        
        renderLine( -b, 0, g.advance+(2*b), 0 );
        renderLine( -b, -_font.ascender, g.advance+(2*b), -_font.ascender );
        renderLine( -b, -_font.descender, g.advance+(2*b), -_font.descender );

        renderLine( -2*b, -_font.descender, -2*b, -_font.descender-_font.height );
        
        renderLine( 0, -b, 0, b );
        renderLine( g.advance, -b, g.advance, b );
                            

    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        var w = width;
        var h = height;

      //  background
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
    }
}
