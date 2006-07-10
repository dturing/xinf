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
import xinf.ony.GeometryEvent;
import xinf.ony.SimpleEvent;

class Box extends Group {
    public var crop(get_crop,set_crop):Bool;
    private var _crop:Bool;
    private var cropParent:Box;

    public function new() {
        _crop = false;
        super();
    }

    /*
        note: the cropping implementation is messy.
        it cannot handle properly:
         * an ancestor element set to crop=true after we've been.
         * setting to crop=false
        could be fixed:
         * unregister CROP_CHANGED events properly when crop set to false
         * trigger cropParent CROP_CHANGED if crop is modified
         * un/re/register parent CROP_CHANGED on parent CROP_CHANGED event.
         * unregister STAGE_SCALE event when crop set to false
		 
		UPDATE: we can just push the scissor box on the attribute stack with glPushAttrib.
		 that will avoid the cropParent mess.
		 the window size problem still remains, though..
    */
    private function get_crop() :Bool {
        return _crop;
    }
    private function set_crop( to:Bool ) :Bool {
        _crop = to;
        if( _crop ) {
            xinf.event.Global.addEventListener( GeometryEvent.STAGE_SCALED, stageSizeChanged );
            changed();
        }
        return _crop;
    }
    
    private function stageSizeChanged( e:GeometryEvent ) {
        if( crop ) {
            // cropping depends on stage size; rerender.
            changed();
        }
    }
    private function setScissors() {
        var win_h = xinf.ony.Root.getRoot().bounds.height;
        var pos:xinf.geom.Point = owner.localToGlobal( new xinf.geom.Point(0,0) );

		// FIXME: parent scissor? do proper test!
        GL.Scissor( Math.round(pos.x), Math.round(win_h-(pos.y+bounds.height)), 
                    Math.round(bounds.width), Math.round(bounds.height) );
    }

    private function _renderGraphics() :Void {
        var b:Float = 0;
        
        var x:Float = -0.25;
        var y:Float = -0.25;
        
        var w:Float = bounds.width-.25;    // w,h are not really width/height here,
        var h:Float = bounds.height-.25;   // but right,bottom!
        
      // background
        if( bgColor != null ) {
			GL.PushAttrib( GL.CURRENT_BIT );
				GL.BindTexture( GL.TEXTURE_2D, 0 );
				GL.Color4f( bgColor.r, bgColor.g, bgColor.b, bgColor.a );
				GL.Begin( GL.QUADS );
					GL.Vertex3f( x, y, 0. );
					GL.Vertex3f( w, y, 0. );
					GL.Vertex3f( w, h, 0. );
					GL.Vertex3f( x, h, 0. );
				GL.End();
			GL.PopAttrib();
        }
    }

    public override function getHitChild( chain:Array<Int>, x:Float, y:Float ) :Object {
        if( crop ) {
            if( x<bounds.x || x > bounds.x+bounds.width
             || y<bounds.y || y > bounds.y+bounds.height ) {
                 throw("cropped hit");
            }
        }
    
        return( super.getHitChild( chain, x, y ) );
    }

    override function _render() :Void {
        _renderGraphics();

        if( _crop ) {
			GL.PushAttrib( GL.SCISSOR_BIT );

			GL.Enable( GL.SCISSOR_TEST );
            setScissors();
            
            super._render();
            
            GL.PopAttrib();
        } else {
            super._render();
        }
    }

    override function _renderSimple() :Void {
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
