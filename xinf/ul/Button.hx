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

import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.event.Event;
import xinf.ony.Text;
import xinf.style.StyleClassElement;

/**
    Button element.
**/

class Button extends StyleClassElement {
	public static var CLICK:String = "buttonClick";

    public var text(get_text,set_text):String;
    private var textE:Text;
	
	private var _mouseUp:Dynamic;
	private var _localMouseUp:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
		super( name, parent );

        textE = new xinf.ony.Text( name+"_text", this );
		setChild( textE );
		
		addEventListener( xinf.event.Event.MOUSE_DOWN, onMouseDown );
    }
    
	private function onMouseDown( e:xinf.event.Event ) {
		addStyleClass(":press");
		xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.MOUSE_UP,
			_mouseUp=onMouseUp );
		addEventListener( xinf.event.Event.MOUSE_UP,
			_localMouseUp=onLocalMouseUp );
	}

	private function onLocalMouseUp( e:xinf.event.Event ) {
		postEvent( Button.CLICK, null );
	}
	
	private function onMouseUp( e:xinf.event.Event ) {
		removeStyleClass(":press");
		xinf.event.EventDispatcher.removeGlobalEventListener( xinf.event.Event.MOUSE_UP,
			_mouseUp );
		removeEventListener( xinf.event.Event.MOUSE_UP,
			_localMouseUp );
	}

	private function get_text() :String {
        return(textE.text);
    }
    private function set_text( t:String ) :String {
        textE.text = if( t=="" || t==null ) " " else t;
        return(t);
    }
}
