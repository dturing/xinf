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

class SimpleListModel<T> implements ListModel<T> {

    private var items:Array<T>;
    
    public function new() :Void {
        items = new Array<T>();
    }
    
    public function addItem( item:T ) :Void {
        items.push( item );
    }

    public function addItems( items:Array<T> ) :Void {
        for( item in items ) {
            this.items.push( item );
        }
    }

    public function getLength() :Int {
        return items.length;
    }

    public function getItemAt( index:Int ) :T {
        return items[index];
    }
    
    public function sort( f:T->T->Int ) :Void {
        items.sort( f );
    }
    
    public static function create<T>( items:Array<T> ) :SimpleListModel<T> {
        var r = new SimpleListModel<T>();
        r.addItems(items);
        return r;
    }
    
}
