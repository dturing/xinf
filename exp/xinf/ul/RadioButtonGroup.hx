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


class SelectableGroup<T:ISelectable> {
	
	public var maxSelections(default,default) :Int;
	public var instances(default,default) :Array<T>;
	public var selectedInstance(getSelectedInstance,null) :T;
	public var selectedInstances(getSelectedInstances,null) :Array<T>;
	
	public function new() {
		maxSelections = 1;
		instances = new Array<T>();
	}
	
	public function addInstance( instance:T ) :Bool {
		if( hasInstance(instance) ) {
			return false;
		} else { 
			instances.push( instance );
			return true;
		}
	}
	
	public function removeInstance( instance:T ) :Bool {
		return instances.remove( instance );
	}
	
	private function hasInstance( instance:T ) :Bool {
		for( inst in instances ) {
			if( inst == instance ) return true;
		}
		return false;
	}
	
	private function getSelectedInstance() :T {
		for( instance in instances ) {
			if( instance.selected ) return instance;
		}
		return null;
	}
	
	private function getSelectedInstances() :Array<T> {
		var arr :Array<T> = new Array<T>();
		for( instance in instances ) {
			if( instance.selected ) arr.push( instance );
		}
		return arr;
	}
	
	public function numSelected() :Int {
		var num :Int = 0;
		for( instance in instances ) {
			if( instance.selected ) num++;
		}
		return num;
	}
	
	private function clearSelections() {
		for( instance in instances ) {
			if( instance.selected ) instance.selected = false;
		}
	}
	
	public function selectInstance( instance:T ) :Bool {
		var num :Int = numSelected();
		if( maxSelections == 1 && num == 1 ) {
			clearSelections();
			return true;
		} else {
			return ( numSelected() < maxSelections );
		}
	}
	
}

import xinf.ul.Button;

class RadioButtonGroup extends SelectableGroup<RadioButton> {

	public function new() {
		super();
	}
		
}