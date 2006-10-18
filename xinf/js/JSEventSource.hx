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

package xinf.js;

import xinf.event.EventKind;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.GeometryEvent;

import js.Dom;

class JSEventSource {
	private var runtime:JSRuntime;

	public function new( r:JSRuntime ) :Void {
		runtime = r;
		
        js.Lib.document.onmousedown = untyped mouseDown;
        js.Lib.document.onmouseup   = untyped mouseUp;
        js.Lib.document.onmousemove = untyped mouseMove;
		
		js.Lib.document.onresize = resizeRoot;
        
		/*
		untyped js.Lib.document.onkeydown = untyped keyPress;
		untyped js.Lib.document.onkeypress = untyped function( e:js.Event ) :Bool {
			trace("hold key "+e.keyCode );
			return true;
		};
		
        // Firefox mousewheel support
        // IE to be done, just use document.onmousewheel there...
        if( untyped js.Lib.window.addEventListener ) {
            untyped js.Lib.window.addEventListener('DOMMouseScroll', this.mouseWheelFF, false);
        }
		*/
	}
/*
	private function keyPress( e:js.Event ) :Bool {
		var key:String = JSEventMonitor.keys.get(e.keyCode);
		trace("key down: "+e.keyCode+" - "+key );
		if( e.keyCode == 0 ) {
			// normal char - handled by browser
			return true;
		} else {
			if( key == null ) {
				trace("unhandled key code "+e.keyCode );
			}
			xinf.ony.FocusManager.handleKeyboardEvent( new KeyboardEvent( 
				KeyboardEvent.KEY_DOWN, null, 0, key,
				untyped e.shiftKey, untyped e.altKey, untyped e.ctrlKey ) );
			// prevent browser from handling it
			return false;
		}
	}
 */   
    private function mouseDown( e:js.Event ) :Bool {
        return postMouseEvent( e, MouseEvent.MOUSE_DOWN );
    }

    private function mouseUp( e:js.Event ) :Bool {
        return postMouseEventTo( e, MouseEvent.MOUSE_UP, 0 );
    }

    private function mouseMove( e:js.Event ) :Bool {
	/*
		var target = findTarget(e);
		if( target != latestOver ) {
			if( latestOver!=null ) postMouseEventTo( e, MouseEvent.MOUSE_OUT, latestOver );
			latestOver = target;
			return postMouseEventTo( e, MouseEvent.MOUSE_OVER, target );				
		} else
			return postMouseEvent( e, MouseEvent.MOUSE_MOVE );
			*/
		return postMouseEventTo( e, MouseEvent.MOUSE_MOVE, 0 );
//		runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_MOVE, e.
    }
/*
    private function mouseWheelFF( e:js.Event ) :Bool {
        var target:Element = findTarget(e);
        if( target!=null ) {
			target.postEvent( new xinf.ony.ScrollEvent( 
							xinf.ony.ScrollEvent.SCROLL_STEP, target, (untyped e.detail/3) ) );
            untyped e.preventDefault();
        }
        return false;
    }
*/
    private function findTarget( e:js.Event ) :Int {
        var targetNode:js.HtmlDom = e.target;
        var targetId:Int = untyped targetNode.xinfId;
        while( targetId == null && targetNode.parentNode != null ) {
            targetNode = targetNode.parentNode;
            if( targetNode != null ) targetId = untyped targetNode.xinfId;
        }
        return targetId;
    }
    
    private function postMouseEvent( e:js.Event, type:EventKind<MouseEvent> ) :Bool {
        var targetId:Int = findTarget(e);
        if( targetId == null ) targetId = 0;
		return postMouseEventTo( e, type, targetId );
	}
	
    private function postMouseEventTo( e:js.Event, type:EventKind<MouseEvent>, targetId:Int ) :Bool {
		runtime.postEvent( new MouseEvent( type, e.clientX, e.clientY, 0, targetId ) );
		
        return e.target.nodeName=="INPUT";
    }

	public function resizeRoot( e:js.Event ) :Void {
		var w = js.Lib.window.innerWidth;
		var h = js.Lib.window.innerHeight;
		runtime.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, w, h ) );
		trace("root resize "+w+"/"+h);
	}
}
