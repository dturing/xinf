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

class SelectableGroup<T:ISelectable> extends SimpleEventDispatcher {
	
	public var maxSelections(default,default) :Int;
	public var items(default,default) :Array<T>;
	public var selectedItem(getSelectedItem,null) :T;
	public var selectedItems(getSelectedItems,null) :Array<T>;
	
	public function new() {
        super();
		maxSelections = 1;
		items = new Array<T>();
	}
	
	public function addItem( item:T ) :Bool {
		if( hasItem(item) ) {
			return false;
		} else { 
			items.push( item );
			return true;
		}
	}
	
	public function removeItem( item:T ) :Bool {
		return items.remove( item );
	}
	
	private function hasItem( item:T ) :Bool {
		for( inst in items ) {
			if( inst == item ) return true;
		}
		return false;
	}
	
	private function getSelectedItem() :T {
		for( item in items ) {
			if( item.selected ) return item;
		}
		return null;
	}
	
	private function getSelectedItems() :Array<T> {
		var arr :Array<T> = new Array<T>();
		for( item in items ) {
			if( item.selected ) arr.push( item );
		}
		return arr;
	}
	
	public function numSelected() :Int {
		var num :Int = 0;
		for( item in items ) {
			if( item.selected ) num++;
		}
		return num;
	}
	
	private function clearSelections() {
		for( item in items ) {
			if( item.selected ) item.selected = false;
		}
	}
	
	public function selectItem( item:T ) :Bool {
		var num :Int = numSelected();
		if( maxSelections == 1 && num == 1) {
			clearSelections();
			return true;
		} else {
			return ( numSelected() < maxSelections );
		}
	}
	
}
