/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.js;

import xinf.event.EventKind;
import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;
import xinf.event.KeyboardEvent;
import xinf.event.GeometryEvent;

import xinf.erno.Keys;

import js.Dom;

class JSEventSource {
    
    private var runtime:JSRuntime;
    private var currentOver:Int;

    public function new( r:JSRuntime ) :Void {
        runtime = r;
        
        js.Lib.document.onmousedown = untyped mouseDown;
        js.Lib.document.onmouseup   = untyped mouseUp;
        js.Lib.document.onmousemove = untyped mouseMove;
        
        js.Lib.document.onresize = rootResized;
        
        untyped js.Lib.document.onkeydown = untyped keyPress;
        untyped js.Lib.document.onkeyup = untyped keyRelease;
        
        untyped js.Lib.document.onkeypress = untyped function( e:js.Event ) :Bool {
        //    trace("hold key "+e.keyCode );
            return false;
        };
        
        // Firefox mousewheel support
        // IE to be done, just use document.onmousewheel there...
        if( untyped js.Lib.window.addEventListener ) {
            untyped js.Lib.window.addEventListener('DOMMouseScroll', this.mouseWheelFF, false);
        }
    }

    private function keyPress( e:js.Event ) :Bool {
        return keyEvent( e, KeyboardEvent.KEY_DOWN );
    }

    private function keyRelease( e:js.Event ) :Bool {
        return keyEvent( e, KeyboardEvent.KEY_UP );
    }
    
    private function keyEvent( e:js.Event, type:EventKind<KeyboardEvent> ) :Bool {
        var key:String = Keys.get(e.keyCode);
        if( key==null ) key = String.fromCharCode(e.keyCode);
        if( e.keyCode == 0 ) {
            // normal char - handled by browser
            return true;
        } else {
            if( key == null ) {
                trace("unhandled key code "+e.keyCode );
                return true;
            }
            runtime.postEvent( new KeyboardEvent( 
                type, e.keyCode, key,
                e.shiftKey>0, e.altKey>0, e.ctrlKey>0 ) );
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
        var targetId:Int = findTarget(e);
        if( targetId != currentOver ) {
            if( currentOver!=null ) {
                postMouseEventTo( e, MouseEvent.MOUSE_OUT, currentOver );
            }
            postMouseEventTo( e, MouseEvent.MOUSE_OVER, targetId );
            currentOver = targetId;
        } else 
            postMouseEventTo( e, MouseEvent.MOUSE_MOVE, targetId );
        return true;
    }

    private function mouseWheelFF( e:js.Event ) :Bool {
        var targetId:Int = findTarget(e);
        if( targetId!=null ) {
            runtime.postEvent( new ScrollEvent( 
                            ScrollEvent.SCROLL_STEP, (untyped e.detail/3), targetId ) );
            untyped e.preventDefault();
        }
        return false;
    }

    private function findTarget( e:js.Event ) :Int {
        var targetNode:js.HtmlDom = e.target;
        while( untyped targetNode.xinfId == null && targetNode.parentNode != null ) {
            targetNode = targetNode.parentNode;
        }
        return untyped targetNode.xinfId;
    }
    
    private function postMouseEvent( e:js.Event, type:EventKind<MouseEvent> ) :Bool {
        var targetId:Int = findTarget(e);
        if( targetId == null ) targetId = 0;
        return postMouseEventTo( e, type, targetId );
    }
    
    private function postMouseEventTo( e:js.Event, type:EventKind<MouseEvent>, targetId:Int ) :Bool {
        runtime.postEvent( new MouseEvent( type, e.clientX, e.clientY, untyped e.which, targetId,
                            e.shiftKey>0, e.altKey>0, e.ctrlKey>0 ) );
        
        return e.target.nodeName=="INPUT";
    }

    public function rootResized( e:js.Event ) :Void {
        var w = js.Lib.window.innerWidth;
        var h = js.Lib.window.innerHeight;
        runtime.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, w, h ) );
    }
    
}
