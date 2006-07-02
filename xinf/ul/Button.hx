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

class Button<T:Element> extends StyleClassElement {
	public static var CLICK:String = "buttonClick";

	public var contained(get_contained,set_contained):T;
	private var _contained:T;
	public function get_contained():T {
		return _contained;
	}
    public function set_contained( c:T ):T {
        _contained = c;
		setChild( c );
		return c;
	}
    
	private var _mouseUp:Dynamic;
	private var _localMouseUp:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
		super( name, parent );
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
}

class TextButton extends Button<xinf.ony.Text> {
	public function new( name:String, parent:Element, ?initialText:String ) :Void {
		super( name, parent );
		var c = new xinf.ony.Text( name+"_text", this );
		if( initialText!=null ) c.text = initialText;
		contained = c;
	}
}

class ImageButton extends Button<xinf.ony.Image> {
	public function new( name:String, parent:Element, ?url:String ) :Void {
		super( name, parent );
		var c = new xinf.ony.Image( name+"_img", this );
		c.autoSize=true;
		contained = c;
		if( url!=null ) c.load(url);
	}
}
