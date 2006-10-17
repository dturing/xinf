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

import xinf.ony.Object;
import xinf.ul.Pane;
import xinf.erno.Runtime;

import xinf.event.MouseEvent;
import xinf.event.EventKind;

/**
    Button element.
**/

class Button<T:Object> extends Widget {
	public static var CLICK = new EventKind<MouseEvent>("buttonClick");

	public var contained(get_contained,set_contained):T;
	private var _contained:T;
	public function get_contained():T {
		return _contained;
	}
    public function set_contained( c:T ):T {
        _contained = c;
		attach( c );
		return c;
	}
    
	private var _mouseUp:Dynamic;
	private var _localMouseUp:Dynamic;
    
    public function new() :Void {
		super();
		addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }
	    
	private function onMouseDown( e:MouseEvent ) {
		addStyleClass(":press");
		Runtime.addEventListener( MouseEvent.MOUSE_UP,
			_mouseUp=onMouseUp );
	}
	
	private function onMouseUp( e:MouseEvent ) {
		if( this._id==e.targetId || this.contained._id==e.targetId )  // FIXME
			postEvent( new MouseEvent( Button.CLICK, e.x, e.y ) );
		
		removeStyleClass(":press");
		Runtime.removeEventListener( MouseEvent.MOUSE_UP,
			_mouseUp );
	}
}

class TextButton extends Button<xinf.ul.Label> {
	public function new( ?initialText:String ) :Void {
		super();
		var c = new xinf.ul.Label();
		attach(c);
		if( initialText!=null ) c.text = initialText;
		contained = c;
	}
	
	public static function createSimple( text:String, f:MouseEvent->Void ) :TextButton {
		var b = new TextButton( text );
		b.addEventListener( Button.CLICK, f );
		return b;
	}
}
/*
class ImageButton extends Button<xinf.ony.Image> {
	public function new( name:String, parent:Element, ?url:String ) :Void {
		super( name, parent );
		var c = new xinf.ony.Image( name+"_img", this );
		c.autoSize=true;
		scaleChild=false;
		if( url!=null ) c.load(url);
		contained = c;
	}
}
*/