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

package xinf.ul.list;

import xinf.ul.model.ISelectable;

class SelectableListItem<T:ISelectable> extends ListItem<T> {

    public function set( ?value:T ) :Void {
        super.set();
        if( value!=null && value.selected ) addStyleClass(":selected") else removeStyleClass(":selected");
        this.value = value;
        this.text = if( value==null ) "" else ""+value;
    }
    
}
