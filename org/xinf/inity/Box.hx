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

package org.xinf.inity;

class Box extends Group {
    public var crop:Bool;

    public function new() {
        crop = false;
        super();
    }

    private function _renderGraphics() :Void {
        var b:Float = 0;
        
        var x:Float = -.5;
        var y:Float = -.5;
        
        var w:Float = bounds.width;    // w,h are not really width/height here,
        var h:Float = bounds.height;   // but right,bottom!
        
      // background
        if( bgColor != null ) {
            GL.Color4f( bgColor.r, bgColor.g, bgColor.b, bgColor.a );
            GL.Begin( GL.QUADS );
                GL.Vertex3f( x, y, 0. );
                GL.Vertex3f( w, y, 0. );
                GL.Vertex3f( w, h, 0. );
                GL.Vertex3f( x, h, 0. );
            GL.End();
        }
    }

    public function getHitChild( chain:Array<Int>, x:Float, y:Float ) :Object {
//            trace("getHitChild "+x+"/"+y+", "+bounds.x+"/"+bounds.y );
        if( crop ) {
            if( x<bounds.x || x > bounds.x+bounds.width
             || y<bounds.y || y > bounds.y+bounds.height ) {
                 throw("cropped hit");
            }
        }
    
        return( super.getHitChild( chain, x, y ) );
    }

    private function startCrop() :Void {
        if( !crop ) return;
        
        GL.Enable( GL.STENCIL_TEST );
        GL.Clear( GL.STENCIL_BUFFER_BIT );

        /* FIXME: stencilling will break when we have a child that crops too. */

        GL.ColorMask( 0,0,0,1 );
        GL.StencilFunc( GL.ALWAYS, 1, 1 );
        GL.StencilOp( GL.KEEP, GL.KEEP, GL.REPLACE );

            var w:Float = bounds.width;   // w,h are not really width/height here,
            var h:Float = bounds.height;  // but right,bottom!
          //  background
            GL.Color4f( 1, 0, 0, 1 );
            GL.Begin( GL.QUADS );
                GL.Vertex3f( w , 0., 0. );
                GL.Vertex3f( w , h , 0. );
                GL.Vertex3f( 0., h , 0. );
                GL.Vertex3f( 0., 0., 0. );
            GL.End();

        GL.StencilFunc( GL.EQUAL, 1, 1 );
        GL.StencilOp( GL.KEEP, GL.KEEP, GL.KEEP );

        GL.ColorMask( 1,1,1,1 );
    }

    private function endCrop() :Void {
        if( !crop ) return;
        
        GL.Disable( GL.STENCIL_TEST );
    }
           
    private function _render() :Void {
        _renderGraphics();
 
        startCrop();
        super._render();
        endCrop();
    }

    private function _renderSimple() :Void {
        // FIXME: this duplicates stuff in _renderGraphics
        var w:Float = bounds.width;   // w,h are not really width/height here,
        var h:Float = bounds.height;  // but right,bottom!

        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
        
        super._renderSimple();
    }
}
