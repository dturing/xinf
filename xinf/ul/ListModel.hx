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

package xinf.ul;

import xinf.event.Event;

interface ListModel {
    function getLength() :Int;
    function getItemAt( index:Int ) :String;
    function addChangedListener( f:xinf.event.Event -> Void ) :Void;
    function removeChangedListener( f:xinf.event.Event -> Void ) :Void;
}

class SimpleListModel extends xinf.event.EventDispatcher, implements ListModel {
    private var items:Array<String>;
    
    public function new() :Void {
        super();
        items = new Array<String>();
    }
    
    public function addItem( text:String ) {
        items.push( text );
        if( hasListeners( Event.CHANGED ) ) {
            postEvent( Event.CHANGED, null );
        }
    }
    
    public function getLength() :Int {
        return items.length;
    }
    
    public function getItemAt( index:Int ) :String {
        return items[index];
    }

    public function addChangedListener( f:xinf.event.Event -> Void ) :Void {
        addEventListener( Event.CHANGED, f );
    }
    
    public function removeChangedListener( f:xinf.event.Event -> Void ) :Void {
        removeEventListener( Event.CHANGED, f );
    }
}
