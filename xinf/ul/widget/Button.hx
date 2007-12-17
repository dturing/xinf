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
import xinf.ul.layout.Helper;
import xinf.ul.FocusManager;
import xinf.erno.Paint;

/**
    Button element.
**/

class Button<Value> extends Widget {
    
    public static var PRESS = new EventKind<ValueEvent<Value>>("buttonPress");

    public var text(get_text,set_text):String;
	var textElement:Text;
    var value:Value;
    var _mouseUp:Dynamic;
	var _keyUp:Dynamic;

    function get_text() :String {
        return(text);
    }
    
    function set_text( t:String ) :String {
        if( t != text ) {
            text = t;
			textElement.text = text;
			styleChanged();
		}
        return(t);
    }

	override public function set_size( s:TPoint ) :TPoint {
		// FIXME: text-anchor center, set center here.
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 );
		textElement.x = Helper.leftOffsetAligned( this, s.x, .5 );
		return super.set_size(s);
	}

    public function new( ?text:String, ?value:Value ) :Void {
		textElement = new Text();
		
        super();

		group.attach( textElement );
		
        this.set_text(text);
        this.value = value;
        group.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }
        
	override public function styleChanged() :Void {
		super.styleChanged();
		
		textElement.style.fontSize = style.fontSize;
		textElement.style.fontFamily = style.fontFamily;
		textElement.style.fill = SolidColor(.5,.5,.5,.5);
		//hmm?
		//trace("style.textColor = " + style.textColor);
		//textElement.style.fill = style.textColor.toSolidColor();
		textElement.styleChanged();
		
		// TODO: fontWeight
		if( text!=null ) {
			setPrefSize( Helper.addPadding( style.getTextFormat().textSize(text), style ) );
		}
    }
	
    function onMouseDown( e:MouseEvent ) {
		addStyleClass(":press");
        _mouseUp = Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
    }
    
    function onMouseUp( e:MouseEvent ) {
        //if( this._id==e.targetId )
		// TODO: onMouseOut?
		    postEvent( new ValueEvent( PRESS, value ) );
        
        removeStyleClass(":press");
        Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
    }
    
    function onKeyDown( e:KeyboardEvent ) {
		switch( e.key ) {
            case "space":
				if( _keyUp!=null ) return;
				addStyleClass(":press");
				var self=this;
				_keyUp = addEventListener( KeyboardEvent.KEY_UP, function(e) {
					if( e.key=="space" ) {
						self.removeStyleClass(":press");
						self.postEvent( new ValueEvent( PRESS, self.value ) );
						self.removeEventListener( KeyboardEvent.KEY_UP, self._keyUp );
						self._keyUp = null;
					}
				});
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
