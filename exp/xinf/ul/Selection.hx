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

import xinf.event.SimpleEventDispatcher;

class Selection<T:ISelectable> extends SimpleEventDispatcher {
    var selected:Array<T>;
    var maxSelected:Int;
    
    public function new( ?maxSelected:Int ) :Void {
        super();
        
        if( maxSelected==null ) maxSelected==0;
        this.maxSelected = maxSelected;
        selected = new Array<T>();
    }
    
    public function select( item:T, isSelected:Bool ) {
        if( isSelected ) {
            while( selected.length >= this.maxSelected ) selected.pop().setSelected(false);
            selected.push( item );
            item.setSelected(true);
        } else {
            selected.remove( item );
            item.setSelected(false);
        }
    }
    
    public function clear() {
        for( item in selected ) item.setSelected(false);
        selected = new Array<T>();
    }
}
