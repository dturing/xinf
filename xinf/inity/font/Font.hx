/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity.font;

import opengl.GL;
import xinf.erno.Renderer;

class Font extends xinf.support.Font {
    
    private static var fonts:Hash<Font> = new Hash<Font>();
    
    public static function getFont( ?name:String, ?weight:Int, ?slant:Int ) :Font {
        if( name==null ) name="_sans";
        if( weight==null ) weight=100;
        if( slant==null ) slant=0;
        
		if( name=="_sans" || name=="" || name==null ) { name="FreeSans"; }
        
        var font:Font;
        font = fonts.get(name);
        if( font != null ) return font;
        
        var data:String;
        var file = ""+xinf.support.Font.findFont(name,weight,slant,12.0);
        if( file==null || file=="" ) throw("Unable to load font "+name+": "+file );

		var font;
		
		try {
			data = neko.io.File.getContent( file );
			font = new Font( data, 12 );
		} catch( e:Dynamic ) {
			trace("Couldn't load font: using bundled Vera: "+e);
			data = neko.io.File.getContent( xinf.support.DLLLoader.getXinfLibPath()+"/../vera.ttf" );
			font = new Font( data, 12 );
		}
        
        fonts.set( name, font );
        return font;
    }

    public var font:xinf.support.Font;
    private var cache:Hash<GlyphCache>;
    // later, maybe: private var outlines:GlyphCache();
	var data:String;

    public function new( data:String, size:Int ) {
		this.data = data;
        var s = Math.round(size<<24);
        super( data, s, s );
        cache = new Hash<GlyphCache>();
    }
    
    public function getGlyph( character:Int, fontSize:Float ) :Glyph {
        var c = cache.get(""+Math.round(fontSize));
        
        if( c==null ) {
//			trace("not cached "+character+" sz "+fontSize );
            c = new GlyphCache( this, Math.round(fontSize), fontSize<=12 );
            cache.set(""+Math.round(fontSize),c);
        }
        
        var g = c.get(character);
        return( g );
    }

    public function textSize( text:String, fontSize:Float, ?lineHeight:Float ) :{x:Float,y:Float} {
        var lines=0;
        if( lineHeight==null ) lineHeight = Math.round(height*fontSize)/fontSize;
        var w=0.0;
        var maxW=0.0;
        for( i in 0...text.length ) {
            var c = text.charCodeAt(i);
            if( c == 10 ) { // \n
                if( w>maxW ) maxW = w;
                w=0;
                lines++;
            } else {
                var g = getGlyph(c,fontSize);
                if( g != null ) {
                    w += g.advance/fontSize;
                }
            }
        }
        if( w>maxW ) maxW=w;
        maxW*=fontSize;
        return { x:maxW, y:(lines+1)*(lineHeight*fontSize) };
    }
    
    public function renderText( text:String, fontSize:Float ) :Void {
        if( text == null ) text="[null]";
        
        var lines=0;
        var c_style=0;
        var r = { x:.0, y:.0 };
        
        GL.pushMatrix();
        
        GL.scale( fontSize, fontSize, 1.0 );
        GL.translate( .0, ascender, .0 ); // FIXME *.9?

        GL.pushMatrix(); // for lines.

        var lineHeight = Math.round(height*fontSize)/fontSize;

        for( i in 0...text.length ) {
            var c = text.charCodeAt(i);
            if( c == 10 ) { // \n
                GL.popMatrix();
                GL.pushMatrix();
                lines++;
                GL.translate( .0, lineHeight*lines, .0 );
            } else {
                var g = getGlyph(c,fontSize);
                if( g != null ) {
                    GL.translate( g.render()/fontSize, 0, 0 );
                }
            }
        }
        GL.popMatrix();

        GL.popMatrix();
        
        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
            }
        #end
    }

    public function toString() :String {
        return("[Font: "+family_name+"]");
    }
}

