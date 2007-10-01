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

package xinf.ul.widget;

import Xinf;
import xinf.event.EventKind;
import xinf.ul.ValueEvent;

/**
    Button element.
**/

class Button<Value> extends Widget {
    
    public static var PRESS = new EventKind<ValueEvent<Value>>("buttonPress");

    public var text(get_text,set_text):String;
	var textElement:Text;
    var value:Value;
    var _mouseUp:Dynamic;

    function get_text() :String {
        return(text);
    }
    
    function set_text( t:String ) :String {
        if( t != text ) {
            text = t;
			textElement.text = text;
// TODO            setPrefSize( getStyleTextFormat().textSize(t) );
        }
        return(t);
    }

    public function new( ?text:String, ?value:Value ) :Void {
        super();
		textElement = new Text();
		group.attach( textElement );
		
        this.set_text(text);
        this.value = value;
        textElement.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }
        
    function onMouseDown( e:MouseEvent ) {
        addStyleClass(":press");
		trace("down!");
        Root.addEventListener( MouseEvent.MOUSE_UP,
            _mouseUp=onMouseUp );
    }
    
    function onMouseUp( e:MouseEvent ) {
        //if( this._id==e.targetId )
		// TODO: onMouseOut?
            postEvent( new ValueEvent( Button.PRESS, value ) );
        
        removeStyleClass(":press");
        Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
    }
    
    function onKeyDown( e:KeyboardEvent ) {
		switch( e.key ) {
            case "space":
                postEvent( new ValueEvent( PRESS, value ) );
        }
    }

	public static function createSimple<Value>( text:String, f:Value->Void, ?value:Value ) :Button<Value> {
        var b = new Button<Value>( text, value );
        b.addEventListener( PRESS, function( e ) {
                f(untyped e.value); // FIXME: this untyped should really not be neccessary, haxe bug?
            } );
        return b;
    } 
}
