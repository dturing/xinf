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

/**
    EventDispatcher is the base class for all objects that can trigger Events
    (most notable, Element and its derivations, and Bounds).
**/
class EventDispatcher {
    /**
        Add a listener function to the global EventDispatcher.
    **/
    static public function addGlobalEventListener( type:String, f:Event->Void ) :Void {
        GlobalEventDispatcher.global.addEventListener( type, f );
    }

    /**
        Remove a listener function from the global EventDispatcher.
    **/
    static public function removeGlobalEventListener( type:String, f:Event->Void ) :Void {
        GlobalEventDispatcher.global.removeEventListener( type, f );
    }
    
    private var _listeners:Hash<Array<Event -> Void>>;
    
    public function new() :Void {
        _listeners = new Hash<Array<Event -> Void>>();
    }

    /**
        Add a listener function for the specified Event type
        to this EventDispatcher. It will be appended
        to the current list of dispatchers, Events will be posted in order
        of registration until someone calls stopPropagation() on the event.
    **/    
    public function addEventListener( type:String, f:Event->Void ) :Void {
        var a:Array<Event->Void> = _listeners.get(type);
        if( a == null ) {
            a = new Array<Event->Void>();
            _listeners.set(type,a);
        }
        a.push(f);
    }


    /**
        Dispatch (deliver) an Event to registered listeners.
        You should not need to call this function directly,
        instead, use postEvent().
    **/
    public function dispatchEvent( e:Event ) :Void {
        var a:Array<Event -> Void> = _listeners.get(e.type);
        if( a != null ) {
            for( listener in a ) {
                listener(e);
                if( e.stopped ) return;
            }
        }
        if( this != GlobalEventDispatcher.global ) GlobalEventDispatcher.global.dispatchEvent( e );
    }


    /**
        Create a new Event of the type specified with the data
        given, set the Event target to this EventDispatcher,
        and post it into the global Event queue. It will be 
        delivered in the next round of Event.processQueue.
    **/
    public function postEvent( type:String, data:Dynamic ) :Event {
        var e:Event = new Event( type, this, data );
        Event.push(e);
        return e;
    }
    

    /**
        returns true if the EventDispatchers has any listeners
        for the Event type specified.
    **/  
    public function hasListeners( type:String ) :Bool {
        var l:Array<Event->Void>;
        l = _listeners.get(type);
        if( l != null && l.length>0 ) return true;
        return false;
    }


    /**
        Removes a listener function from this EventDispatcher.
    **/
    public function removeEventListener( type:String, f:Event->Void ) :Void {
        var a:Array<Event->Void> = _listeners.get(type);
        if( a != null ) {
            a.remove( f );
        }
    }
}
