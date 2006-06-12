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
        GL.Color4f( bgColor.r, bgColor.g, bgColor.b, bgColor.a );
        GL.Begin( GL.QUADS );
            GL.Vertex3f( x, y, 0. );
            GL.Vertex3f( w, y, 0. );
            GL.Vertex3f( w, h, 0. );
            GL.Vertex3f( x, h, 0. );
        GL.End();
    }
    
    private function _render() :Void {
        _renderGraphics();
        
        if( crop ) {
            /* note: xinfinity uses scissor, which is likely faster
               and enjoys wider support (is this both true? maybe not!)
               it's a bit weird though, and only applies to integer pixels
               
               additionally, how we do it here is very, very hacky (FIXME).
               AND it doesnt go well with resizing windows (sigh).
               */
            var pos:org.xinf.geom.Point = untyped owner.localToGlobal( new org.xinf.geom.Point(10,0) );
            var win_h:Float = untyped org.xinf.ony.Root.getRoot()._p.height;
            trace("crop pos: "+pos+", win_h "+win_h );

            GL.Scissor( Math.round(pos.x), Math.round(win_h-(pos.y+bounds.height)),
                Math.round( bounds.width ), Math.round( bounds.height ) );
            GL.Enable( GL.SCISSOR_TEST );
            super._render();
            GL.Disable( GL.SCISSOR_TEST );
        } else {
            super._render();
        }
    }

    private function _renderSimple() :Void {
        // FIXME: this duplicates stuff in _renderGraphics
        var w:Float = bounds.width;   // w,h are not really width/height here,
        var h:Float = bounds.height;  // but right,bottom!

      //  background
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
        
        super._renderSimple();
    }
}
