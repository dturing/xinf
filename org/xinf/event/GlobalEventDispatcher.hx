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

package org.xinf.event;

#if js
import js.Dom;
#end

import org.xinf.event.Event;


/**
    GlobalEventDispatcher cares about registration of some specific global events
    that require runtime-specific handling. On the outside, it behaves just like
    a normal EventDispatcher. You should register events on it thru EventDispatcher's
    static addGlobalEventListener/removeGlobalEventLister methods.
**/
class GlobalEventDispatcher extends EventDispatcher {
    /**
        The one global EventDispatcher. Some Events are not specific to any
        EventHandler (eg. ENTER_FRAME). Those will be dispatched on this global one.
    **/
    static public var global:EventDispatcher = new GlobalEventDispatcher();
    
    #if js
        private function _mouseMove( e:js.Event ) {
            GlobalEventDispatcher.global.postEvent( org.xinf.event.Event.MOUSE_MOVE, { x:e.clientX,y:e.clientY } );
        }
        private function _mouseUp( e:js.Event ) {
            GlobalEventDispatcher.global.postEvent( org.xinf.event.Event.MOUSE_UP, { x:e.clientX,y:e.clientY } );
        }
    #else flash
        private function _mouseUp() {
            GlobalEventDispatcher.global.postEvent( org.xinf.event.Event.MOUSE_UP, { x:untyped this._xmouse, y:untyped this._ymouse } );
        }
        private function _mouseMoveMaybe() {
            untyped {
                var p = flash.Lib._root;
                if( p._xmouse != this._mousex || p._ymouse != this._mousey ) {
                    this._mousex = p._xmouse; this._mousey = p._ymouse;
                    org.xinf.event.GlobalEventDispatcher.global.postEvent( Event.MOUSE_MOVE, { x:untyped this._mousex, y:untyped this._mousey } );
                }
            }
        }
        private var __mouseMoveMaybe:Dynamic;
        public function registerGlobalMouseMove() :Void {
            __mouseMoveMaybe = this._mouseMoveMaybe;
            org.xinf.event.EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, __mouseMoveMaybe );
        }
        public function unregisterGlobalMouseMove() :Void {
            org.xinf.event.EventDispatcher.removeGlobalEventListener( Event.ENTER_FRAME, __mouseMoveMaybe );
        }
    #end
    
    private function registerEvent( type:String ) :Void {
        #if js
            if( type == org.xinf.event.Event.MOUSE_MOVE ) {
                untyped js.Lib.document.onmousemove = _mouseMove;
            } else if( type == org.xinf.event.Event.MOUSE_UP ) {
                untyped js.Lib.document.onmouseup = _mouseUp;
            }
        #else flash
            if( type == org.xinf.event.Event.MOUSE_MOVE ) {
                registerGlobalMouseMove();
            } else if( type == org.xinf.event.Event.MOUSE_UP ) {
                untyped flash.Lib._root.onMouseUp = _mouseUp;
            }
        #end
    }

    private function unregisterEvent( type:String ) :Void {
        #if js
            if( type == org.xinf.event.Event.MOUSE_MOVE ) {
                untyped js.Lib.document.onmousemove = null;
            } else if( type == org.xinf.event.Event.MOUSE_UP ) {
                untyped js.Lib.document.onmouseup = null;
            }
        #else flash
            if( type == org.xinf.event.Event.MOUSE_MOVE ) {
                unregisterGlobalMouseMove();
            } else if( type == org.xinf.event.Event.MOUSE_UP ) {
                untyped flash.Lib._root.onMouseUp = null;
            }
        #end
    }

    public function addEventListener( type:String, f:org.xinf.event.Event->Void ) :Void {
        if( !hasListeners( type ) ) registerEvent( type );

        var a:Array<org.xinf.event.Event->Void> = _listeners.get(type);
        if( a == null ) {
            a = new Array<org.xinf.event.Event->Void>();
            _listeners.set(type,a);
        }
        a.push(f);
    }

    public function removeEventListener( type:String, f:org.xinf.event.Event->Void ) :Void {
        var a:Array<org.xinf.event.Event->Void> = _listeners.get(type);
        if( a != null ) {
            a.remove( f );
        }
        
        if( !hasListeners( type ) ) unregisterEvent( type );
    }
}
