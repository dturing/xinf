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
import xinf.event.Event;

class EventMonitor {
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
        postMouseEvent( target, Event.MOUSE_DOWN );
    }

    private function mouseUp( targetPath:String ) {
        var target = findTarget( targetPath );
        postMouseEvent( target, Event.MOUSE_UP );
    }

    private function mouseMove( targetPath:String ) {
        var target = findTarget( targetPath );
        
        if( target == null ) return;
        
        if( target != latestOver ) {
            postMouseEvent( latestOver, Event.MOUSE_OUT );
            latestOver = target;
            postMouseEvent( target, Event.MOUSE_OVER );
        } else {
			xinf.event.EventDispatcher.postGlobalEvent( Event.MOUSE_MOVE, { x:flash.Lib._root._xmouse, y:flash.Lib._root._ymouse } );
            //postMouseEvent( target, Event.MOUSE_MOVE );
        }
    }

    private function mouseWheel( targetPath:String, delta:Int ) {
        var target = findTarget( targetPath );
        target.postEvent( Event.SCROLL_STEP, { delta:-delta } );
    }
    
    private function postMouseEvent( target:Element, type:String ) :Void {
        target.postEvent( type, { x:flash.Lib._root._xmouse, y:flash.Lib._root._ymouse } );
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
