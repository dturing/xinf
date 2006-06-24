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

package xinf.inity;

import xinf.inity.Font;
import xinf.geom.Point;

class Text extends Box {
    // FIXME this loads the font for each text item, eeew!
    private static var _font:Font = Font.getFont("Bitstream Vera Sans");

    public var text( _getText, _setText ) : String;
    private var _text:String;
    public var length( _getLength, null ) : Int;
    public var fontSize:Float;

    public function new() {
        super();
        _text = "";
        fontSize = 12;
    }

    private function _getLength() : Int {
        return _text.length;
    }
    
    private function _setText( t:String ) : String {
        _text = t;
        changed();
        return t;
    }

    private function _getText() : String {
        return _text;
    }
    
    public function getTextExtends() : Point {
        var w:Float = .0;
        var maxW:Float = .0;
        var lines:Int = 1;
        for( i in 0..._text.length ) {
            var c = _text.charCodeAt(i);
            if( c == 10 && i != _text.length-1 ) { // \n
                lines++;
                if( w > maxW ) maxW = w;
                w = .0;
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    w += g.advance * fontSize;
                }
            }
        }
        if( w > maxW ) maxW = w;
        return( new Point( maxW, (_font.height * fontSize * lines)+4 ) );
    }
    
    private function _renderGraphics() :Void {
        var lines:Int = 0;

        super._renderGraphics();
        
    // text
        GL.PushMatrix();
        GL.Color4f( fgColor.r, fgColor.g, fgColor.b, fgColor.a );

        GL.Translatef( .75, .75, .0 );
        
        GL.Scalef( fontSize, fontSize, 1.0 );
        GL.Translatef( .0, _font.ascender, .0 );
        GL.Translatef( .0, .0, .0 );
        
        GL.PushMatrix();
        
        for( i in 0..._text.length ) {
            var c = _text.charCodeAt(i);
            if( c == 10 ) { // \n
                GL.PopMatrix();
                GL.PushMatrix();
                lines++;
                GL.Translatef( .0, _font.height*lines, .0 );
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    g.render();
                }
            }
        }

        GL.PopMatrix();
        
        GL.PopMatrix();
    }
}
