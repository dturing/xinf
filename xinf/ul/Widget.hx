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

import xinf.ony.Element;
import xinf.ony.FocusManager;
import xinf.ony.KeyboardEvent;
import xinf.style.StyleClassElement;
import xinf.event.Global;


/**
    Widget base class.
	Takes care of Keyboard Focus.
**/
class Widget extends StyleClassElement {
    public function new( name:String, parent:Element ) :Void {
		super( name, parent );
		FocusManager.registerElement(this);
		
		addEventListener( KeyboardEvent.KEY_DOWN, handleKeyboardEvent );
		addEventListener( KeyboardEvent.KEY_UP, handleKeyboardEvent );
    }
	
	override public function focus() :Void {
		addStyleClass(":focus");
		trace("FOCUS "+this );
	}

	override public function blur() :Void {
		removeStyleClass(":focus");
	}

	public function handleKeyboardEvent( e:KeyboardEvent ) :Void {
		if( e.target != child && child != null ) {
			e.target = child;
			child.dispatchEvent( e );
		}
	}
}
