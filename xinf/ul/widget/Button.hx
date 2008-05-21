/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.event.EventKind;
import xinf.event.SimpleEvent;
import xinf.ul.layout.Helper;
import xinf.ul.FocusManager;

/**
    Button element.
**/

class Button extends Widget {
    
    public static var PRESS = new EventKind<SimpleEvent>("buttonPress");

    public var text(get_text,set_text):String;
	
	var textElement:Text;
	var _pressedOver:Dynamic;
    var _mouseUp:Dynamic;
    var _mouseOver:Dynamic;
	var _mouseOut:Dynamic;
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
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 ) + textElement.fontSize;
		textElement.x = Helper.leftOffsetAligned( this, s.x, .5 );
		return super.set_size(s);
	}

    public function new( ?text:String ) :Void {
		textElement = new Text();
    	
        super();

	    this.set_text(text);
		group.appendChild( textElement );
        
        group.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }
        
	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged();
		if( text!=null ) {
			setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
		}
		if( size!=null ) set_size(size);
    }
	
    function onMouseDown( e:MouseEvent ) {
		addStyleClass(":press");
		_pressedOver = true;
        _mouseUp = Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
        _mouseOver = group.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
        _mouseOut = group.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
    }

	function onMouseOver( e:MouseEvent ) {
		_pressedOver = true;
		addStyleClass(":press");
	}

	function onMouseOut( e:MouseEvent ) {
		_pressedOver = false;
		removeStyleClass(":press");
	}

    function onMouseUp( e:MouseEvent ) {
        if( _pressedOver )
		    postEvent( new SimpleEvent( PRESS ) );
        
        removeStyleClass(":press");
        Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
        group.removeEventListener( MouseEvent.MOUSE_OVER, _mouseOver );
        group.removeEventListener( MouseEvent.MOUSE_OUT, _mouseOut );
    }
    
    function onKeyDown( e:KeyboardEvent ) {
		if( e.key==" " ) {
			addStyleClass(":press");
			_keyUp = addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		}
	}
		
	function onKeyUp( e:KeyboardEvent ) {
		if( e.key==" " ) {
			removeStyleClass(":press");
			postEvent( new SimpleEvent( PRESS ) );
			removeEventListener( KeyboardEvent.KEY_UP, _keyUp );
		}
    }

	public static function createSimple( text:String, f:Void->Void ) :Button {
        var b = new Button( text );
        b.addEventListener( PRESS, function( e ) {
                f();
            } );
        return b;
    } 
}
