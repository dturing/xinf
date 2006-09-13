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

package xinf.ony.flash;

import xinf.ony.Element;
import xinf.ony.MouseEvent;
import xinf.event.EventKind;

class FlashEventMonitor {
    private var mouseTrackingClip:flash.MovieClip;
    private var latestOver:Element;

    public function new() :Void {
        // create the mouseTrackingClip we use for finding
        // mouse event targets
        
        var m = mouseTrackingClip = flash.Lib._root.createEmptyMovieClip( "__xinf__mouseTrackingClip", 65000 );
        var self = this;
        mouseTrackingClip.startDrag( true );
        mouseTrackingClip.onMouseDown = function() {
            self.mouseDown( m._droptarget );
        }
        mouseTrackingClip.onMouseUp = function() {
            self.mouseUp( m._droptarget );
        }
        mouseTrackingClip.onMouseMove = function() {
            self.mouseMove( m._droptarget );
        }
        
        var mouseListener:Dynamic = { 
            onMouseWheel : function(delta) {
                self.mouseWheel( m._droptarget, delta );
            }
        };
        flash.Mouse.addListener( mouseListener );
    }
    
    private function mouseDown( targetPath:String ) {
        var target = findTarget( targetPath );
        postMouseEvent( target, MouseEvent.MOUSE_DOWN );
    }

    private function mouseUp( targetPath:String ) {
        var target = findTarget( targetPath );
        postMouseEvent( target, MouseEvent.MOUSE_UP );
    }

    private function mouseMove( targetPath:String ) {
        var target = findTarget( targetPath );
        
        if( target == null ) return;
        
        if( target != latestOver ) {
            postMouseEvent( latestOver, MouseEvent.MOUSE_OUT );
            latestOver = target;
            postMouseEvent( target, MouseEvent.MOUSE_OVER );
        } else {
			// FIXME: this is different from js and inity, but maybe better.
			xinf.event.Global.postEvent( 
				new MouseEvent( MouseEvent.MOUSE_MOVE, target, 
					Math.round(flash.Lib._root._xmouse), 
					Math.round(flash.Lib._root._ymouse) ) );
        }
    }

    private function mouseWheel( targetPath:String, delta:Int ) {
        var target = findTarget( targetPath );
        target.postEvent( new xinf.ony.ScrollEvent( 
							xinf.ony.ScrollEvent.SCROLL_STEP, target, -delta ) );
    }
    
    private function postMouseEvent( target:Element, type:EventKind<MouseEvent> ) :Void {
		target.postEvent( new MouseEvent( type, target,
								Math.round(flash.Lib._root._xmouse), 
								Math.round(flash.Lib._root._ymouse) ) );
    }
    
    private function findTarget( path:String ) :Element {
        var targets:Array<String> = path.split("/");
        targets.shift();
        
        var e:flash.MovieClip = flash.Lib._root;
        var o:Element;
        for( t in targets ) {
            if( e == null ) throw("Target not found: "+path );
            if( untyped e.owner ) o = untyped e.owner;
            e = untyped e[t];
        }
        if( untyped e.owner ) o = untyped e.owner;
        return o;
    }
}
