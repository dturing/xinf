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
import xinf.event.Event;
import xinf.ony.MouseEvent;

import xinf.ul.Button;

/**
    Slider (numeric entry) element.
**/

class Slider extends xinf.ul.Combo<xinf.ul.Label,ImageButton> {
	private var _mouseUp:Dynamic;
	private var _mouseMove:Dynamic;
	private var slideBar:Element;
	private var slideThumb:Element;
	
	public var precision:Float;
	public var min:Float;
	public var max:Float;
	public var mouseOffset:Int;
	public var valueOffset:Float;
	
	private var _value:Float;
	public var value(get_value,set_value):Float;
	public function get_value() :Float {
		return _value;
	}
	public function set_value( v:Float ) :Float {
		_value = v;
		left.text = ""+Math.floor( precision*v )/precision;
		return _value;
	}
	public function get_normalized() :Float {
		return (_value-min)/(max-min);
	}
	public function set_normalized( v:Float ) :Float {
		if( v<.0 ) v=.0; else if( v>1. ) v=1.;
		_value = min + (v*(max-min));
		left.text = ""+Math.floor( precision*_value )/precision;
		return v;
	}	
    public function new( name:String, parent:Element ) :Void {
		super( name, parent );
		precision=1000; min=0; max=1;
	
		setLeft( new xinf.ul.Label(name+"_lbl", this ) );
		// FIXME: image should be part of the style.
		setRight( new ImageButton(name+"_btn", this, "assets/slider/icon.png" ) );
		right.autoSize = false;
		
		slideBar = new xinf.ony.Image(name+"_slide", this, "assets/slider/bg.png");
		slideBar.visible = false;

		slideThumb = new xinf.ony.Image(name+"_thumb", this, "assets/slider/handle.png");
		slideThumb.bounds.setPosition( 2, 1 );
		slideThumb.visible = false;

		value = .0;

		addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }
	
	private function onMouseDown( e:MouseEvent ) {
		if( _mouseUp == null ) {
			addStyleClass( ":focus" );
		
			xinf.event.Global.addEventListener( 
				MouseEvent.MOUSE_UP, _mouseUp=onMouseUp );
			xinf.event.Global.addEventListener( 
				MouseEvent.MOUSE_MOVE, _mouseMove=onMouseMove );
				
			var y = -(100-(get_normalized()*100));
			slideBar.bounds.setPosition( right.bounds.x, y );
			slideThumb.bounds.setPosition( 2+slideBar.bounds.x, (101-(get_normalized()*100))+slideBar.bounds.y );
			slideBar.visible = true;
			slideThumb.visible = true;
			
			mouseOffset = e.y;
			valueOffset = get_normalized();
		}
	}
	
	private function onMouseUp( e:MouseEvent ) {
		removeStyleClass( ":focus" );

		xinf.event.Global.removeEventListener( 
			MouseEvent.MOUSE_UP, _mouseUp );
		xinf.event.Global.removeEventListener( 
			MouseEvent.MOUSE_MOVE, _mouseMove );
		_mouseUp = null;
		
		slideBar.visible = false;
		slideThumb.visible = false;
	}

	private function onMouseMove( e:MouseEvent ) {
		set_normalized( (valueOffset + ((e.y-mouseOffset)/-100)) );
		slideThumb.bounds.setPosition( 2+slideBar.bounds.x, (101-(get_normalized()*100))+slideBar.bounds.y );
	}
}
