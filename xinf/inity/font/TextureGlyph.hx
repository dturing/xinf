/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.inity.font;

import cptr.CPtr;
import opengl.GL;

class TextureGlyph extends Glyph {

	var texture:Int;
	var w:Float;
	var h:Float;
	var tx1:Float;
	var ty1:Float;
	var tx2:Float;
	var ty2:Float;
	
	var x1:Float;
	var y1:Float;
	var x2:Float;
	var y2:Float;
	var size:Int;
	
	public function new( character:Int, font:Font, size:Int, hint:Bool ) {
		super(0);
		this.size = size;
		var b = font.renderGlyph( character, size<<6, hint );
		setBitmap( b, size );
	}
	
	public function setBitmap( b:{ width:Int, height:Int, bitmap:Dynamic,x:Int,y:Int,advance:Float }, fontHeight:Int ) {
		advance = b.advance/(1<<6)/size;
		var twidth = 2; while( twidth<b.width+3 ) twidth<<=1;
		var theight = 2; while( theight<b.height+3 ) theight<<=1;

		w = (b.width+2)/(twidth);
		h = (b.height+2)/(theight);
  
  		var bd=1/fontHeight;

		var by = Math.ceil(b.y/(1<<6))/fontHeight;
		y1=-by-bd;
		y2=y1+(b.height/fontHeight)+(2*bd);

		var bx = Math.floor(b.x/(1<<6))/fontHeight;
		x1=bx-bd;
		x2=x1+(b.width/fontHeight)+(2*bd);

		var t:Dynamic = CPtr.uint_alloc(1);
		GL.genTextures(1,t);
		texture = CPtr.uint_get(t,0);
		
		GL.pushAttrib( GL.ENABLE_BIT );
		GL.enable( GL.TEXTURE_2D );
		
			GL.bindTexture( GL.TEXTURE_2D, texture ); // unneccessarryy?
			GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
			GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
			GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
			GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
			GL.texImage2D( GL.TEXTURE_2D, 0, GL.ALPHA, twidth, theight, 0, GL.ALPHA, GL.UNSIGNED_BYTE, null );
			GL.texImageClearFT( texture, twidth, theight );

			// FIXME: check this earlier? crashes only on cr's nvidia!
			if( b.width>0 && b.height>0 ) {
				GL.texSubImageFT( texture, 1, 1, b.width, b.height, b.bitmap );
			}

		GL.popAttrib();

		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
			}
		#end
	}
	
	override public function render( fontHeight:Float ) :Float {
		if( texture!=null ) {
			GL.pushAttrib( GL.ENABLE_BIT );
				GL.enable( GL.TEXTURE_2D );
				GL.bindTexture( GL.TEXTURE_2D, texture );

				GL.begin( GL.QUADS );
					GL.texCoord2( 0, 0 );
					GL.vertex2  ( x1, y1 ); 
					GL.texCoord2( w, 0 );
					GL.vertex2  ( x2, y1 );
					GL.texCoord2( w, h );
					GL.vertex2  ( x2, y2 ); 
					GL.texCoord2( 0, h );
					GL.vertex2  ( x1, y2 ); 
				GL.end();
				
			GL.popAttrib();
		} else {
			trace("Trying to render TextureGlyph, but no bitmap set.");
		}
		return(advance);
	}
}
