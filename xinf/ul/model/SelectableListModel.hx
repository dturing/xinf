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

class SelectableListModel<T> implements ListModel<Selectable<T>> {

    private var items:Array<Selectable<T>>;
    
    public function new() :Void {
        items = new Array<Selectable<T>>();
    }
    
    public function addItem( item:T ) :Void {
        items.push( new Selectable(item) );
    }

    public function addItems( items:Array<T> ) :Void {
        for( item in items ) {
            this.items.push( new Selectable(item) );
        }
    }

    public function getLength() :Int {
        return items.length;
    }

    public function getItemAt( index:Int ) :Selectable<T> {
        return items[index];
    }
    
    public function sort( f:T->T->Int ) :Void {
        items.sort( function(a,b) {
                return f( a.item, b.item );
            });
    }
    
    public static function create<T>( items:Array<T> ) :SelectableListModel<T> {
        var r = new SelectableListModel<T>();
        r.addItems(items);
        return r;
    }
    
}
