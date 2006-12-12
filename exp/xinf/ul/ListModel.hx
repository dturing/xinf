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
import xinf.event.SimpleEvent;
import xinf.event.SimpleEventDispatcher;

interface ListModel<T> {
    function getLength() :Int;
    function getItemAt( index:Int ) :T;
    function getNameAt( index:Int ) :String;
    function addChangedListener( f:SimpleEvent -> Void ) :Void;
    function removeChangedListener( f:SimpleEvent -> Void ) :Void;
}

class SimpleListModel extends SimpleEventDispatcher, implements ListModel<String> {
    private var items:Array<String>;
    
    public function new() :Void {
        super();
        items = new Array<String>();
    }
    
    public function addItem( text:String ) {
        items.push( text );
		// FIXME: provide a way to add a lot of items with triggering only one change event.
		postEvent( new SimpleEvent( SimpleEvent.CHANGED ) );
    }
    
    public function getLength() :Int {
        return items.length;
    }
    
    public function getItemAt( index:Int ) :String {
        return items[index];
    }

    public function getNameAt( index:Int ) :String {
        return items[index];
    }

    public function addChangedListener( f:SimpleEvent -> Void ) :Void {
        addEventListener( SimpleEvent.CHANGED, f );
    }
    
    public function removeChangedListener( f:SimpleEvent -> Void ) :Void {
        removeEventListener( SimpleEvent.CHANGED, f );
    }
	
	public function sort() :Void {
		items.sort( function( a:String, b:String ) :Int {
				if( a>b ) return 1;
				if( b>a ) return -1;
				return 0;
			} );
	}
}
