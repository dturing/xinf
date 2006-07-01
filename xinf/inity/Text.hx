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
import xinf.ony.Color;

signature StyleChange {
	var pos:Int;
	var color:Color;
}

class Text extends Box {
	// FIXME
	public static var _font:Font = Font.getFont("Bitstream Vera Sans");

    public var text( _getText, _setText ) : String;
    private var _text:String;
    public var length( _getLength, null ) : Int;
    public var fontSize:Float;
	
	public var styles:Array<StyleChange>;

    public function new() :Void {
		super();

		styles = new Array<StyleChange>();
        _text = "";
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
                    w += Math.round( g.advance * fontSize );
                }
            }
        }
        if( w > maxW ) maxW = w;
        return( new Point( maxW, (_font.height * fontSize * lines) ) );
    }
    
    override function _renderGraphics() :Void {
        var lines:Int = 0;
		
		var style:Int = 0;
		var nextStyle:StyleChange = styles[style];

        super._renderGraphics();
        
    // text
        GL.PushMatrix();
        GL.Color4f( fgColor.r, fgColor.g, fgColor.b, fgColor.a );

        GL.Translatef( -0.5, 0.25, .0 );
        
        GL.Scalef( fontSize, fontSize, 1.0 );
        GL.Translatef( .0, _font.ascender, .0 );
        GL.Translatef( .0, .0, .0 );
        
        GL.PushMatrix();
        
        for( i in 0..._text.length ) {
			if( nextStyle != null && nextStyle.pos == i ) {
				GL.Color4f( nextStyle.color.r, nextStyle.color.g, nextStyle.color.b, nextStyle.color.a );
				style++;
				nextStyle = styles[style];
			}
			
            var c = _text.charCodeAt(i);
            if( c == 10 ) { // \n
                GL.PopMatrix();
                GL.PushMatrix();
                lines++;
                GL.Translatef( .0, Math.round(_font.height*lines*fontSize)/fontSize, .0 );
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    g.render(fontSize);
                }
            }
        }

        GL.PopMatrix();
        
        GL.PopMatrix();
    }
}
