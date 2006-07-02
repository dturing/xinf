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

class Bitmap extends Group {
    public var data:BitmapData;

    public var alpha:Float;

    public function new() {
        super();
        alpha = 1.0;
    }

	public function load( uri:String ) {
		data = BitmapData.newByName( uri );
		changed();
	}

    private function _renderGraphics() :Void {
		if( data == null ) return;

		var x:Float = 0;
        var y:Float = 0;
        var w:Float = bounds.width;   // w,h are not really width/height here,
        var h:Float = bounds.height;  // but right,bottom!

        if( w==0 && h==0 ) {
            w = data.width;
            h = data.height;
        }        
        
      // image
		GL.PushAttrib( GL.CURRENT_BIT );
			GL.Color4f( 1., 1., 1., alpha );
			data.render( w, h, 0, 0, 1, 1 );
		GL.PopAttrib();
    }
    override private function _render() :Void {
//    trace("render bitmap, dl "+_displayList+" tex "+untyped data.texture );
        _renderGraphics();
        super._render();
    }

    override private function _renderSimple() :Void {
        var w = bounds.width;
        var h = bounds.height;

      //  background
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w, 0, 0. );
            GL.Vertex3f( w, h, 0. );
            GL.Vertex3f( 0, h, 0. );
            GL.Vertex3f( 0, 0, 0. );
        GL.End();
        
        super._renderSimple();
    }
    
}
