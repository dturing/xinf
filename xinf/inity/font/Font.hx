/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.inity.font;

import opengl.GL;
import xinf.erno.Renderer;

class Font extends xinf.support.Font {
	
	private static var fonts:Hash<Font> = new Hash<Font>();
	var kerning:IntHash<IntHash<Float>>;
	
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
			font = new Font( data );
		} catch( e:Dynamic ) {
			trace("Couldn't load font: using bundled Vera: "+e);
			data = neko.io.File.getContent( xinf.support.DLLLoader.getXinfLibPath()+"/../vera.ttf" );
			font = new Font( data );
		}
		
		font.kerning = new IntHash<IntHash<Float>>();
		font.iterateKerningPairs( function(a,b,v) {
				var k = font.kerning.get(a);
				if( k==null ) {
					k = new IntHash<Float>();
					font.kerning.set(a,k);
				}
				k.set(b,v/(1<<6));
//				trace("setkern "+String.fromCharCode(a)+""+String.fromCharCode(b)+": "+v);
//				trace("kern "+a+" "+b+" -> "+v );
			});
		
		fonts.set( name, font );
		return font;
	}

	private var cache:IntHash<GlyphCache>;
	// later, maybe: private var outlines:GlyphCache();
	var data:String;

	public function new( data:String ) {
		this.data = data;
		super( data );
		cache = new IntHash<GlyphCache>();
	}
	
	public function getCache( fontSize:Float ) :GlyphCache {
		var sz = Math.ceil(fontSize);
		
		if( sz>500 ) {
			trace("Should create outline GlyhpCache for size "+sz );
			sz=500;
		}
		
		// FIXME. getting tricky here, but might be good...
		// maybe snap to pixel boundaries, too? or NEAREST?
		if( fontSize>16 ) {
			var lod = Math.ceil( Math.max( Math.sqrt( fontSize ), 6 ));
			sz = Math.ceil(Math.pow( lod, 2 ));
		}
		var c = cache.get(sz);
		
		if( c==null ) {
			trace("Create GlyphCache sz "+sz );
			c = new GlyphCache( this, sz, false ); 
					// hinting? for sz<=12: fontSize<=12 );
			cache.set(sz,c);
		}
		
		return c;
	}
	
	/* DEPRECATED!
	public function getGlyph( character:Int, fontSize:Float ) :Glyph {
		var lod = Math.ceil( Math.max( Math.sqrt( fontSize ), 6 ));
		var c = cache.get(lod);
		
		if( c==null ) {
//			trace("not cached "+character+" lod "+lod+" sz "+fontSize );
			c = new GlyphCache( this, Math.ceil(Math.pow( lod, 2 )), false ); 
					// hinting for sz<=12: fontSize<=12 );
			cache.set(lod,c);
		}
		
		var g = c.get(character);
		return( g );
	}
	*/

	function kern( a:Int, b:Int ) :Float {
		if( a==null ) return 0;
		var k=kerning.get(a);
		if( k!=null ) {
			var v = k.get(b);
			if( v!=null ) {
				trace("kern "+String.fromCharCode(a)+String.fromCharCode(b)+": "+v);
				return v;
			}
		}
		return 0;
	}

	public function textSize( text:String, fontSize:Float, ?lineHeight:Float ) :{x:Float,y:Float} {
		var lines=0;
		if( lineHeight==null ) lineHeight = Math.round(height*fontSize)/fontSize;
		var cache = getCache( fontSize );
		
		var w=0.0;
		var maxW=0.0;
		for( i in 0...text.length ) {
			var c = text.charCodeAt(i);
			if( c == 10 ) { // \n
				if( w>maxW ) maxW = w;
				w=0;
				lines++;
			} else {
				var g = cache.get(c);
				if( g != null ) {
					w += g.advance;
				}
			}
		}
		if( w>maxW ) maxW=w;
		maxW*=fontSize;
		return { x:maxW, y:(lines+1)*(lineHeight*fontSize) };
	}
	
	public function renderText( text:String, fontSize:Float ) :Void {
		if( text == null ) return;
		if( text == "" ) return;

		var cache = getCache( fontSize );
		
		var lines=0;
		var c_style=0;
		var r = { x:.0, y:.0 };
		
		GL.pushMatrix();
		
		GL.scale( fontSize, fontSize, 1.0 );
		GL.translate( .0, ascender, .0 ); // FIXME *.9?

		GL.pushMatrix(); // for lines.

		var lineHeight = Math.round(height*fontSize)/fontSize;

		var self=this;
		var prev=null;
		neko.Utf8.iter(text, function(c:Int) {
			if( c == 10 ) { // \n
				GL.popMatrix();
				GL.pushMatrix();
				lines++;
				GL.translate( .0, lineHeight*lines, .0 );
			} else {
				var g = cache.get(c);
				if( g != null ) {
				//	GL.translate( self.kern(prev,c), 0, 0 );
					GL.translate( g.render(fontSize), 0, 0 );
				}
			}
			prev=c;
		 });
/*
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
*/		
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

