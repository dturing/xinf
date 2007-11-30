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

package xinf.ul.model;

class NameListModel<T> extends SimpleEventDispatcher, implements ListModel<T> {
    
    private var names:Array<String>;
    private var items:Array<T>;
    
    public function new() :Void {
        super();
        names = new Array<String>();
        items = new Array<T>();
    }
    
    public function addItem( name:String, value:T ) {
        items.push( value );
        names.push( name );
        
        // FIXME: provide a way to add a lot of items with triggering only one change event.
        postEvent( new SimpleEvent( SimpleEvent.CHANGED ) );
    }
    
    public function getLength() :Int {
        return items.length;
    }
    
    public function getItemAt( index:Int ) :T {
        return items[index];
    }

    public function getNameAt( index:Int ) :String {
        return names[index];
    }

    public function addChangedListener( f:SimpleEvent -> Void ) :Void {
        addEventListener( SimpleEvent.CHANGED, f );
    }
    
    public function removeChangedListener( f:SimpleEvent -> Void ) :Void {
        removeEventListener( SimpleEvent.CHANGED, f );
    }
    
}