/***********************************************************************

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
   
***********************************************************************/

package org.xinf.event;

class Event {
    static public var queue:Array<Event>;
    static public function push( e:Event ) :Void {
        if( queue == null ) queue = new Array<Event>();
        queue.push(e);
    }
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
        //    trace("Delivering "+e.type+" "+e.data+" to "+e.target );
            e.target.dispatchEvent( e );
            e.stopPropagation(); // some event generators, like Value::changed(), rely on this! maybe do another flag "delivered"?
            e=queue.shift();
        }
        /*
        if( n>100 ) {
            trace("event queue processed "+n+" Events total");
        }
        */
    }

    public static var ENTER_FRAME:String = "enterFrame";
    
    public static var MOUSE_DOWN:String = "mouseDown";
    public static var MOUSE_UP:String = "mouseUp";
    public static var MOUSE_MOVE:String = "mouseMove";
    public static var MOUSE_OVER:String = "mouseOver";
    public static var MOUSE_OUT:String = "mouseOut";

    public static var KEY_DOWN:String = "keyDown";
    public static var KEY_UP:String = "keyUp";
    
    public static var STYLE_CHANGED:String = "styleChanged";
    public static var SIZE_CHANGED:String = "sizeChanged";
    
    public static var CHANGED:String = "changed";
    
    /*
    public static var FRESH:Int = 0;
    public static var SCHEDULED:Int = 1;
    public static var DELIVERING:Int = 2;
    public static var DELIVERED:Int = 3;
    public static var STOPPED:Int = 99;
    */
    
    public var type(default,null) : String;
    public var target(default,null) : EventDispatcher;
    public var stopped(default,null) : Bool;
    public var data(default,null) : Dynamic;
//    public var state(default,null) : Int;
    
    
    public function new( _type:String, _target:EventDispatcher, _data:Dynamic ) :Void {
        data = _data;
        type = _type;
        target = _target;
        stopped = false;
    }
    
    public function stopPropagation() :Void {
        stopped = true;
    }
    
    // FIXME: do this different, use data!
    public static function KeyboardEvent( type:String, target:EventDispatcher, key:String ) :Event {
        var e:Event = new Event( type, target, { key:key } );
        return e;
    }
}
