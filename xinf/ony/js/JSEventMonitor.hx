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

package xinf.ony.js;

import xinf.ony.Element;
import xinf.ony.MouseEvent;
import xinf.ony.KeyboardEvent;
import xinf.event.EventKind;

import js.Dom;

class JSEventMonitor {
    private static var rootX:Int;
    private static var rootY:Int;
    private var latestOver:Element;
	
	private static var keys:IntHash<String>;

	private static function __init__() :Void {
		keys = new IntHash<String>();
		keys.set(8,"backspace");
		keys.set(9,"tab");
		keys.set(27,"escape");
		keys.set(32,"space");
		keys.set(33,"page up");
		keys.set(34,"page down");
		keys.set(37,"left");
		keys.set(38,"up");
		keys.set(39,"right");
		keys.set(40,"down");
	}
	
    public function new() :Void {
        var self = this;
        js.Lib.document.onmousedown = untyped mouseDown;
        js.Lib.document.onmouseup   = untyped mouseUp;
        js.Lib.document.onmousemove = untyped mouseMove;
        
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
    }
	
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
    
    private function mouseDown( e:js.Event ) :Bool {
        return postMouseEvent( e, MouseEvent.MOUSE_DOWN );
    }

    private function mouseUp( e:js.Event ) :Bool {
        return postMouseEvent( e, MouseEvent.MOUSE_UP );
    }

    private function mouseMove( e:js.Event ) :Bool {
		var target = findTarget(e);
		if( target != latestOver ) {
			if( latestOver!=null ) postMouseEventTo( e, MouseEvent.MOUSE_OUT, latestOver );
			latestOver = target;
			return postMouseEventTo( e, MouseEvent.MOUSE_OVER, target );				
		} else
			return postMouseEvent( e, MouseEvent.MOUSE_MOVE );
    }

    private function mouseWheelFF( e:js.Event ) :Bool {
        var target:Element = findTarget(e);
        if( target!=null ) {
			target.postEvent( new xinf.ony.ScrollEvent( 
							xinf.ony.ScrollEvent.SCROLL_STEP, target, (untyped e.detail/3) ) );
            untyped e.preventDefault();
        }
        return false;
    }

    private static  function findTarget( e:js.Event ) :Element {
        var targetNode:js.HtmlDom = e.target;
        var target:Element = untyped targetNode.owner;
        while( target == null && targetNode.parentNode != null ) {
            targetNode = targetNode.parentNode;
            if( targetNode != null ) target = untyped targetNode.owner;
        }
        return target;
    }
    
    private static function postMouseEvent( e:js.Event, type:EventKind<MouseEvent> ) :Bool {
        var target:Element = findTarget(e);
        if( target == null ) return true;
		return postMouseEventTo( e, type, target );
	}
	
    private static function postMouseEventTo( e:js.Event, type:EventKind<MouseEvent>, target:Element ) :Bool {
        if( rootX == null ) {
            untyped {
                var root = untyped xinf.ony.Root.getRoot()._p;
                rootX = root.offsetLeft;
                rootY = root.offsetTop;
            }
        }
            
        target.postEvent( new MouseEvent( type, target, e.clientX - rootX, e.clientY - rootY ) );
        
        untyped {
            if( e.stopPropagation ) e.stopPropagation();
        }
        return e.target.nodeName=="INPUT";
    }
}
