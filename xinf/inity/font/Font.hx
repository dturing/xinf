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

import opengl.GL;
import xinf.erno.Renderer;
import xinf.erno.FontStyle;

class Font {
    
    private static var fonts:Hash<Font> = new Hash<Font>();
    
    public static function getFont( ?name:String, ?weight:Int, ?slant:Int, ?dontCache:Bool ) :Font {
        if( name==null ) name="_sans";
        if( dontCache==null ) dontCache=false;
        if( weight==null ) weight=100;
        if( slant==null ) slant=0;
        
        var font:Font;
        font = fonts.get(name);
        if( font != null ) return font;
        
        var data:String;
        if( name=="_sans" ) {
            data = Std.resource("default-font");
            if( data==null ) {
                // try to load bitstream vera- bundled with xinfinity
                untyped {
                    var module = __dollar__loader.loadmodule("xinf-resources".__s,__dollar__loader);
                    data = module.font;
                }
                if( data == null ) {
                    throw("default font not found - include xinf-resources");
                }
            }
        } else if( name!=null ) {
            var file = ""+xinf.support.Font.findFont(name,weight,slant,12.0);
            if( file==null || file=="" ) throw("Unable to load font "+name+": "+file );
            data = neko.io.File.getContent( file );
        }
        font = new FontReader( data ).getFont();
        
        fonts.set( name, font );
        return font;
    }
    
    private static var glyphsToCache:Array<Glyph> = new Array<Glyph>();
    
    public static function cacheGlyphs() :Void {
        var g:Glyph;
        while( (g = glyphsToCache.shift())!=null ) {
        // FIXME: this should depend on actual pixel size..
        //          50 is quite too much for 20pt, but too little for 1000. 
        //          GLPolygon has some pixelSize sh*t.
            g.cache(50.0);
        }
    }
    
    public static function cacheGlyph( g:Glyph ) :Void {
        glyphsToCache.push(g);
    }
    
    private var glyphs:IntHash<Glyph>;
    
    public var family_name(default,null):String;
    public var style_name(default,null):String;
    public var ascender(default,null):Float;
    public var descender(default,null):Float;
    public var height(default,null):Float;
    public var underline_thickness(default,null):Float;
    public var underline_position(default,null):Float;
    public var units_per_EM(default,null):Float;
    
    public function new() {
        glyphs = new IntHash<Glyph>();
    }
    
    public function getGlyph( character:Int ) :Glyph {
        var g:Glyph = glyphs.get(character);
        return( g );
    }

    public function getGlyphs() :IntHash<Glyph> {
        return glyphs;
    }
    
    public function addGlyph( character:Int, g:Glyph ) :Void {
        glyphs.set(character,g);
    }
    
    public function textSize( text:String, fontSize:Float ) :{x:Float,y:Float} {
        var lines=0;
        var lineHeight = Math.round(height*fontSize)/fontSize;
        var w=0.0;
        var maxW=0.0;
        for( i in 0...text.length ) {
            var c = text.charCodeAt(i);
            if( c == 10 ) { // \n
                if( w>maxW ) maxW = w;
                w=0;
                lines++;
                GL.translate( .0, lineHeight*lines, .0 );
            } else {
                var g = getGlyph(c);
                if( g != null ) {
                    w += g.advance;
                }
            }
        }
        if( w>maxW ) maxW=w;
        maxW*=fontSize;
        return { x:maxW, y:(lines+1)*(lineHeight*fontSize) };
    }
    
    public function renderText( text:String, fontSize:Float, style:FontStyle ) :Void {
        if( text == null ) text="[null]";
        
        var lines=0;
        var c_style=0;
        var r = { x:.0, y:.0 };
        var nextStyle:FontStyleChange = null;
        if( style!=null ) nextStyle = style[c_style];
        
        GL.pushMatrix();
        
        GL.scale( fontSize, fontSize, 1.0 );
        GL.translate( .0, ascender, .0 );

        GL.pushMatrix(); // for lines.

        var lineHeight = Math.round(height*fontSize)/fontSize;

        for( i in 0...text.length ) {
            if( nextStyle != null && nextStyle.pos == i ) {
                GL.color4( nextStyle.color.r, nextStyle.color.g, nextStyle.color.b, nextStyle.color.a );
                c_style++;
                nextStyle = style[c_style];
            }
            
            var c = text.charCodeAt(i);
            if( c == 10 ) { // \n
                GL.popMatrix();
                GL.pushMatrix();
                lines++;
                GL.translate( .0, lineHeight*lines, .0 );
            } else {
                var g = getGlyph(c);
                if( g != null ) {
                    g.render(fontSize)*fontSize;
                }
            }
        }
        GL.popMatrix();

        GL.popMatrix();
    }

    public function toString() :String {
        return("[Font: "+family_name+"]");
    }
}

