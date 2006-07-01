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

package xinf.event;

/**
    Event is a User-Interface (or other) Event. It will be passed through the
    hierarchy of xinfony elements until it is handled or discarded.
    <br/>
    The Event class also (statically) manages the global event queue, and
    defines STATIC_VARIABLES for the core xinfony event types.
**/
class Event {
    static private var queue:Array<Event>;
    /**
        Push (post) an Event to the global Event queue. 
        Events are processed in FIFO (first-in-first-out) order.
    **/
    static public function push( e:Event ) :Void {
        if( queue == null ) queue = new Array<Event>();
        queue.push(e);
    }
    
    /**
        Process all pending events. Do not call this function directly
        except if you know what you are doing. It will be called in
        regular intervals (once every frame) once you passed control
        to xinfony with Root.getRoot().run();
    **/
    static public function processQueue() :Void {
        if( queue == null ) return;
        var e:Event = queue.shift();
       // if( queue.length > 0 ) trace("processQueue: "+queue.length+" events" );
        
        if( queue.length > 100 ) {
            trace( queue.length+" is an astonishing number of events, breakdown: ");
            
            var h = new Hash<Int>();
            for( event in queue ) {
                var t:String = event.type;
                var i:Int = h.get(t);
                if( i==null ) i=0;
                i++;
                h.set(t,i);
            }
            
            for( type in h.keys() ) {
                trace( h.get(type) + "\t:"+type );
            }
        }
        
        var n=0;
        while( e != null ) {
            n++;
    //        if( e.type != Event.ENTER_FRAME ) trace("Delivering "+e.type+" "+e.data+" to "+e.target );
            e.target.dispatchEvent( e );
            e=queue.shift();
        }
        /*
        if( n>100 ) {
            trace("event queue processed "+n+" Events total");
        }
        */
    }

    /**
        Triggered globally when the application should quit (xinfinity only).
    **/
    public static var QUIT:String = "quit";

    /**
        The ENTER_FRAME is a global event that will be dispatched once for
        every frame cycle. You can listen for it to do animations or other
        functionality that need regular updates.
    **/
    public static var ENTER_FRAME:String = "enterFrame";
    
    /**
        MOUSE_DOWN is dispatched on an Element when a mouse button is pressed
        while the mouse curser is above the Element (and no other Element is in
        front of it).
    **/
    public static var MOUSE_DOWN:String = "mouseDown";

    /**
        MOUSE_UP is dispatched on an Element when a mouse button is released
        while the mouse curser is above the Element (and no other Element is in
        front of it). It does not matter if the button was pressed while
        the cursor was on the element.
    **/
    public static var MOUSE_UP:String = "mouseUp";

    /**
        dispatched on an Element when a mouse button is released
        outside the element area, while it was pressed while inside.
    **/
    public static var MOUSE_UP_OUTSIDE:String = "mouseUpOutside";

    /**
        MOUSE_MOVE is dispatched on an Element whenever the mouse cursor moves 
        *within* the bounding rectangle of the Element.
    **/
    public static var MOUSE_MOVE:String = "mouseMove";

    /**
        MOUSE_OVER is dispatched on an Element whenever the mouse cursor moves 
        *into* the bounding rectangle of the Element.
    **/
    public static var MOUSE_OVER:String = "mouseOver";

    /**
        MOUSE_OVER is dispatched on an Element whenever the mouse cursor moves 
        *out of* the bounding rectangle of the Element.
    **/
    public static var MOUSE_OUT:String = "mouseOut";


    /**
        KEY_DOWN is dispatched globally 
        when a key is pressed while the player application has
        keyboard focus.
    **/
    public static var KEY_DOWN:String = "keyDown";

    /**
        KEY_UP is dispatched globally 
        when a key is released while the player application has
        keyboard focus.
    **/
    public static var KEY_UP:String = "keyUp";
    
    /** dispatched on a Bounds rectangle when it's position changed **/
    public static var POSITION_CHANGED:String = "positionChanged";
    /** dispatched on a Bounds rectangle when it's size changed **/
    public static var SIZE_CHANGED:String = "sizeChanged";

    /** xinfinity only: dispatched on a Box when it's cropping changed **/
    public static var CROP_CHANGED:String = "cropChanged";

    /** generic "changed" event -- something changed. **/
    public static var CHANGED:String = "changed";

    /** Scrollbar is scrolled. data.value denotes the new position (0-1). **/
    public static var SCROLLED:String = "scrolled";
    /** Scrollbar is scrolled by a step. data.direction is 0 (up) or 1 (down).
        You must update the scrollbar yourself. **/
    public static var SCROLL_STEP:String = "scrollStep";
    /** Scrollbar is scrolled by a leap (page). data.direction is 0 (up) or 1 (down).
        You must update the scrollbar yourself. **/
    public static var SCROLL_LEAP:String = "scrollLeap";

    /** triggered when the Stage is resized. data contains w,h describing new size 
        FIXME: only works in xinfinity (yet) **/
    public static var STAGE_SCALE:String = "stageScale";

    /** triggered on Image once completely loaded **/
    public static var LOADED:String = "loaded";

    /** triggered on Menu/Listbox when an item is chosen **/
    public static var ITEM_PICKED:String = "itemPicked";

	/** when a StyledElement has been set a new Style, and needs update **/
	public static var STYLE_CHANGED:String = "styleChanged";

    /** type of the Event. It's a string, but you should only use
        the STATIC_VARS defined above to set or compare Event types **/
    public var type(default,null) : String;

    /** the EventDispatcher that the Event was posted on **/
    public var target(default,null) : EventDispatcher;

    /** Event data. Mouse events carry a { x, y, button } structure (FIXME: not quite),
        keyboard events information about which key was pressed (FIXME: not unified),
        other events might carry other information. **/
    public var data(default,null) : Dynamic;

    /** Constructor **/
    public function new( _type:String, _target:EventDispatcher, _data:Dynamic ) :Void {
        data = _data;
        type = _type;
        target = _target;
    }

    public function toString() :String {
        return( "<"+type+" to "+target+", "+data+">" );
    }
}
