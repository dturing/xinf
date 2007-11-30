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

import Xinf;
import xinf.ul.model.ISelectable;

/*
	the ugly #if flash9 untyped stuff here is due to the bug
	discussed in
	http://lists.motion-twin.com/pipermail/haxe/2007-July/010655.html
*/

#if flash9
class SelectableListItem<T> extends ListItem<T> {
#else true
class SelectableListItem<T:ISelectable> extends ListItem<T> {
#end
    override public function set( ?value:T ) :Void {
  //      super.set();
        this.value = value;
		if( value!=null ) {
			#if flash9
			untyped {
			#end
			if( value.selected ) this.text.style.fill = Color.RED;
		//	else this.text.style.fill = Color.BLACK;
			trace( value.selected );
			#if flash9
			}
			#end
		}
        this.text.text = if( value==null ) "" else ""+value;
    }
}
