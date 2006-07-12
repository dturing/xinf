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

package xinf.ony;

/**
	Keyboard Focus manager singleton
**/
class FocusManager {
	private static var widgets:Array<Element>;
	private static var currentFocus:Int;
	
	public static function setup() :Void {
		if( widgets==null ) {
			widgets = new Array<Element>();
			currentFocus=-1;
		}
	}
	
	public static function registerElement( w:Element, ?index:Int ) :Void {
		setup();
		if( index != null ) {
			widgets.insert( index, w );
		} else {
			widgets.push(w);
			index=widgets.length-1;
		}
		if( currentFocus==-1 ) next();
	}

	public static function unregisterElement( w:Element ) :Bool {
		setup();
		return widgets.remove(w);
	}

	public static function next() :Void {
		if( widgets==null ) return;
		if( currentFocus >= 0 ) widgets[currentFocus].blur();
		currentFocus++;
		if( currentFocus >= widgets.length ) currentFocus=0;
		if( currentFocus >= 0 ) widgets[currentFocus].focus();
	}

	public static function previous() :Void {
		if( widgets==null ) return;
		if( currentFocus >= 0 ) widgets[currentFocus].blur();
		currentFocus--;
		if( currentFocus < 0 ) currentFocus=widgets.length-1;
		if( currentFocus >= 0 ) widgets[currentFocus].focus();
	}
	
	public static function handleKeyboardEvent( e:KeyboardEvent ) :Void {
		if( widgets==null ) return;
		if( e.type == KeyboardEvent.KEY_DOWN && e.key == "tab" ) {
			if( e.shiftMod ) previous();
			else next();
			return;
		}
		if( currentFocus >= 0 ) {
			widgets[currentFocus].dispatchEvent(e);
		}
	}
}