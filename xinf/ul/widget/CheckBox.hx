/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.event.EventKind;
import xinf.ul.ValueEvent;
import xinf.ul.layout.Helper;
import xinf.ul.FocusManager;

class CheckBox extends Widget {

	public static var CHANGED = new EventKind<ValueEvent<Bool>>("checkboxChange");

	public var text(get_text,set_text):String;
	var textElement:Text;
	var outerRect:Rectangle;
	var innerRect:Rectangle;
	var _mouseUp:Dynamic;
	var _keyUp:Dynamic;

	public var selected(default,set_selected) :Bool;
	
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

	public function set_selected( sel:Bool ) :Bool {
		if( sel != selected) {
			selected = sel;
			if (sel) {
				addStyleClass(":select");
				group.appendChild(innerRect);
			} else {
				removeStyleClass(":select");
				group.removeChild(innerRect);
			}
			postEvent( new ValueEvent<Bool>( CHANGED, sel ) );
		}
		return sel;
	}

	override public function set_size( s:TPoint ) :TPoint {
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 ) + textElement.fontSize;
		textElement.x = 15+Helper.leftOffsetAligned( this, s.x, 0. );
		outerRect.x = Helper.leftOffsetAligned( this, s.x, 0. );
		outerRect.y = Helper.topOffsetAligned( this, s.x, 0. );
		return super.set_size(s);
	}

	public function new( text:String ) :Void {
		textElement = new Text();
		outerRect = new Rectangle({ width:13, height:13, x:1, y:1, fill:"gray", stroke:"black", stroke_thickness:1. });
		innerRect = new Rectangle({ width:8, height:8, x:2, y:5 });
		
		super();

		group.appendChild( textElement );
		group.appendChild( outerRect );
		group.appendChild( innerRect );
		
		this.set_text(text);
		
		group.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		
		selected = false;
	}
	
	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged();
		
		innerRect.fill = focusColor;
		
		if( text!=null ) {
			var s = getTextFormat().textSize(text);
			s.x += 15;
			s.y = Math.max(s.y,15);
			setPrefSize( Helper.addPadding( s, this ) );
		}
		if( size!=null ) set_size(size);
	}

	function onMouseDown( e:MouseEvent ) {
		addStyleClass(":press");
		_mouseUp = Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
	}
	
	function onMouseUp( e:MouseEvent ) {
		selected = !selected;
//			postEvent( new ValueEvent( PRESS, value ) );
		
		removeStyleClass(":press");
		Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
	}
	
	function onKeyDown( e:KeyboardEvent ) {
		switch( e.key ) {
			case " ":
				if( _keyUp!=null ) return;
				addStyleClass(":press");
				var self=this;
				_keyUp = addEventListener( KeyboardEvent.KEY_UP, function(e) {
					if( e.key==" " ) {
						self.removeStyleClass(":press");
						self.selected = !self.selected;
						self.removeEventListener( KeyboardEvent.KEY_UP, self._keyUp );
						self._keyUp = null;
					}
				});
		}
	}

	public static function createSimple( text:String, f:Bool->Void ) :CheckBox {
		var b = new CheckBox( text );
		b.addEventListener( CheckBox.CHANGED, function(e) {
			f(e.value);
		} );
		return b;
	}
	
}
