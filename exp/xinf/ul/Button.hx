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
import xinf.erno.Runtime;

import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.SimpleEvent;
import xinf.event.EventKind;

import xinf.erno.Renderer;
import xinf.erno.Color;

/**
    Button element.
**/

class Button<Value> extends Widget {
    
    public static var PRESS = new EventKind<ValueEvent<Value>>("buttonPress");

    public var text(get_text,set_text):String;
    var value:Value;
    var _mouseUp:Dynamic;

    function get_text() :String {
        return(text);
    }
    
    function set_text( t:String ) :String {
        text = t;
        scheduleRedraw();
        return(t);
    }

    public function new( ?text:String, ?value:Value ) :Void {
        super();
        this.text = text;
        this.value = value;
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }
        
    function onMouseDown( e:MouseEvent ) {
        addStyleClass(":press");
        Runtime.addEventListener( MouseEvent.MOUSE_UP,
            _mouseUp=onMouseUp );
    }
    
    function onMouseUp( e:MouseEvent ) {
        if( this._id==e.targetId )
            postEvent( new ValueEvent( Button.PRESS, value ) );
        
        removeStyleClass(":press");
        Runtime.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
    }
    
    function onKeyDown( e:KeyboardEvent ) {
        switch( e.key ) {
            case "space":
                postEvent( new ValueEvent( Button.PRESS, value ) );
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
    
        setStyleFill( g, "color" );
        g.text(style.padding.l+style.border.l,style.padding.t+style.border.t,text,getStyleTextFormat());
    }

    public static function createSimple<Value>( text:String, f:Value->Void, ?value:Value ) :Button<Value> {
        var b = new Button<Value>( text, value );
        b.addEventListener( Button.PRESS, function( e ) {
                f(e.value);
            } );
        return b;
    }
    
}
