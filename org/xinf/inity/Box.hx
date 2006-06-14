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
    */
    private function get_crop() :Bool {
        return _crop;
    }
    private function set_crop( to:Bool ) :Bool {
        _crop = to;
        if( _crop ) {
            // FIXME untyped!
            untyped owner.bounds.addEventListener( org.xinf.event.Event.SIZE_CHANGED, sizeChanged );
    
            cropParent = findCropParent();
            if( cropParent != null ) {
                cropParent.owner.addEventListener( org.xinf.event.Event.CROP_CHANGED, parentCropChanged );
                org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.STAGE_SCALE, stageSizeChanged );
            }
            changed();
        }
        return _crop;
    }
    
    private function findCropParent() :Box {
        var o:Object = this.parent;
        if( o == null ) return null;
        while( o.parent != null ) {
            try {
                var b = cast(o,Box);
                if( b.crop ) return b;
            } catch( e:Dynamic ) {
            }
            o = o.parent;
        }
        return null;
    }
    private function sizeChanged( e:org.xinf.event.Event ) {
        if( crop ) {
            owner.postEvent( org.xinf.event.Event.CROP_CHANGED, null );
        }
    }
    private function stageSizeChanged( e:org.xinf.event.Event ) {
        if( crop ) {
            // cropping depends on stage size; rerender.
            changed();
        }
    }
    private function parentCropChanged( e:org.xinf.event.Event ) {
        if( crop && e.data != this ) {
            owner.postEvent( org.xinf.event.Event.CROP_CHANGED, this );
        }
    }
    private function setScissors() {
        var win_h = org.xinf.ony.Root.getRoot().bounds.height;
        // FIXME...
        var pos:org.xinf.geom.Point = untyped owner.localToGlobal( new org.xinf.geom.Point(0,0) );

        // FIXME: take parent crop into account...
        GL.Scissor( Math.round(pos.x), Math.round(win_h-(pos.y+bounds.height)), 
                    Math.round(bounds.width), Math.round(bounds.height) );
    }

    private function _renderGraphics() :Void {
        var b:Float = 0;
        
        var x:Float = 0;//-.5;
        var y:Float = 0;//-.5;
        
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

    private function _render() :Void {
        _renderGraphics();

        if( _crop ) {
            if( cropParent==null ) {
                GL.Enable( GL.SCISSOR_TEST );
            }
            setScissors();
            
            super._render();
            
            if( cropParent==null ) {
                GL.Disable( GL.SCISSOR_TEST );
            } else {
                cropParent.setScissors();
            }
        } else {
            super._render();
        }
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
