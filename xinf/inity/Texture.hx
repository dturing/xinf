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

enum ColorSpace {
    RGB;
    RGBA;
}

class Texture {
	// texture id and size, size must be 2^n
	private var texture:Int;
    private var twidth:Int;
    private var theight:Int;

	// image size - what part is actually used of the texture
    public var width(default,null):Int;
    public var height(default,null):Int;
	
	private function new( w:Int, h:Int, tw:Int, th:Int, tex:Int ) {
		width=w; height=h;
		twidth=tw; theight=th;
		texture=tex;
	}

    public function render( w:Float, h:Float, rx:Float, ry:Float, rw:Float, rh:Float ) {
//        trace("BitmapData:render "+texture+" - "+w+","+h+" // "+rx+","+ry+" "+rw+","+rh );
        var tx1:Float = (rx/twidth)*w;
        var ty1:Float = (ry/theight)*h;
        var tx2:Float = ( (rw+rx) / twidth ) * w * (width/w);
        var ty2:Float = ( (rh+ry) / theight ) * h * (height/h);

	//	GL.PushAttrib( GL.ENABLE_BIT );
			GL.Enable( GL.TEXTURE_2D );
			GL.BindTexture( GL.TEXTURE_2D, texture );

			var x:Float = -.25;
			var y:Float = -.25;
			w+=x;
			h+=y;

			GL.Begin( GL.QUADS );
				GL.TexCoord2f( tx1, ty1 );
				GL.Vertex2f  (   x,   y ); 
				GL.TexCoord2f( tx2, ty1 );
				GL.Vertex2f  (   w,   y ); 
				GL.TexCoord2f( tx2, ty2 );
				GL.Vertex2f  (   w,   h ); 
				GL.TexCoord2f( tx1, ty2 );
				GL.Vertex2f  (   x,   h ); 
			GL.End();

     //   GL.PopAttrib();
    }
}
