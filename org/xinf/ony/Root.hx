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

package org.xinf.ony;

import org.xinf.event.Event;

#if js
import js.Dom;
#end

/**
    Root is the root Element of a xinfony application. 
    Depending on the runtime, the root is either a specific DIV element with an ID of "xinfony" (for JS), the Stage (for Flash), or the player root (for xinfinity).

    There should be only one root. At the start of your application, you should assure the Root is created by calling getRoot() once.
    After initialization of your application's elements, you should call run() on the Root.  
    
    Root will take care of posting global ENTER_FRAME events.
**/
class Root extends Element {
    private static var root:Root;
    
    private var _r:
        #if neko
            org.xinf.inity.Root
        #else js
            js.HtmlDom
        #else flash
            flash.MovieClip
        #end
        ;

    #if js
	    private static var arr = new Array<Root>();
    	private var timerId : Int;
    #end

    private function new() {
        super("root",null);
    }
    
    private function createPrimitive() :Dynamic {
        _r = 
            #if neko
                new org.xinf.inity.Root(320,240)
            #else js
                js.Lib.document.getElementById("xinfony")
            #else flash
                flash.Lib._root
            #end
            ;
        return _r;
    }
    
    /**
        Return the one, global, singleton Root instance.
    **/
    public static function getRoot() : Root {
        if( root == null ) {
            root = new Root();
        }
        return root;
    }

    /**
        Pass application control to xinfony. You should call this after initializing
        your application. Any further action you do will be caused by Events.
    **/    
    public function run() : Void {
        #if neko
            _r.run();
        #else js
		    var id = arr.length;
	    	arr[id] = this;
    		timerId = untyped window.setInterval("org.xinf.ony.Root.arr["+id+"].step();",40);
        #else flash
            _p.onEnterFrame = step;
        #end
    }
    
    #if js
        public function step() :Void {
            org.xinf.event.EventDispatcher.global.postEvent( Event.ENTER_FRAME, { } );
            org.xinf.event.Event.processQueue();
        }
    #else flash
        public function step() :Void {
            org.xinf.event.EventDispatcher.global.postEvent( Event.ENTER_FRAME, { } );
            org.xinf.event.Event.processQueue();
        }
    #end
}
