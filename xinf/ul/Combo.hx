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

class Combo<Left:StyleClassElement,Right:StyleClassElement> extends StyleClassElement {
	public static var CLICK:String = "buttonClick";

    public var left:Left;
	public var right:Right;
	
	private var _mouseUp:Dynamic;
	private var _localMouseUp:Dynamic;
    
    public function new( name:String, parent:Element) :Void {
		super( name, parent );
		addEventListener( xinf.event.Event.MOUSE_DOWN, onMouseDown );
    }
	
	public function setLeft( l:Left ) :Void {
		left=l;
		left.addStyleClass("combo");

        // FIXME: unregister old handler
        left.bounds.addEventListener( Event.SIZE_CHANGED, childSizeChanged );
        updateSize();
	}

	public function setRight( r:Right ) :Void {
		right=r;
		right.addStyleClass("combo");

	// FIXME: unregister old handler
        right.bounds.addEventListener( Event.SIZE_CHANGED, childSizeChanged );
        updateSize();
	}

	
	override private function onMouseOver( e:xinf.event.Event ) :Void {
		super.onMouseOver(e);
		left.addStyleClass(":hover");
		right.addStyleClass(":hover");
	}
	override private function onMouseOut( e:xinf.event.Event ) :Void {
		super.onMouseOver(e);
		left.removeStyleClass(":hover");
		right.removeStyleClass(":hover");
	}
	private function onMouseDown( e:xinf.event.Event ) {
		addStyleClass(":press");
		xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.MOUSE_UP,
			_mouseUp=onMouseUp );
		addEventListener( xinf.event.Event.MOUSE_UP,
			_localMouseUp=onLocalMouseUp );
	}

	private function onLocalMouseUp( e:xinf.event.Event ) :Void {
		postEvent( Button.CLICK, null );
	}
	
	private function onMouseUp( e:xinf.event.Event ) {
		removeStyleClass(":press");
		xinf.event.EventDispatcher.removeGlobalEventListener( xinf.event.Event.MOUSE_UP,
			_mouseUp );
		removeEventListener( xinf.event.Event.MOUSE_UP,
			_localMouseUp );
	}

    override public function childSizeChanged( e:Event ) :Void {
        if( autoSize ) {
            updateSize();
        }
    }

	override private function updateSize() :Void {
		if( left!=null && right!=null ) {
			right.bounds.setPosition( left.bounds.width, 0 );
		}
	}
}
