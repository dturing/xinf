/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.layout.Helper;
import xinf.ony.type.Editability;
import xinf.ul.ValueEvent;

class LineEdit extends Widget {
	public static var TEXT_CHANGED = new xinf.event.EventKind<ValueEvent<String>>("textChanged");

	public var text(get_text,set_text) :String;
	private var textElement:TextArea;
	
	var changed:Bool;

	private function get_text() :String {
		return textElement.text;
	}
	
	private function set_text(t:String) :String {
		textElement.text = t;
		changed = true;
		setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
		return t;
	}
	
	override public function set_size( s:TPoint ) :TPoint {
		// FIXME: text-anchor center, set center here.
		var s2 = Helper.removePadding( s, this );
		textElement.width = s2.x+5;
		textElement.height = s2.y+2;
		var p = Helper.innerTopLeft(this);
		textElement.x = p.x;
		textElement.y = p.y;
		return super.set_size(s);
	}

	public function new( ?traits:Dynamic ) :Void {
		textElement = new TextArea();
		super( traits );

		textElement.editable = Editability.Simple;
		group.appendChild( textElement );
		
		textElement.addEventListener( SimpleEvent.CHANGED, textChanged );
		textElement.addEventListener( UIEvent.ACTIVATE, activate );
		
//		addEventListener( KeyboardEvent.KEY_DOWN, textElement.onKeyDown );
//		group.addEventListener( MouseEvent.MOUSE_DOWN, textElement.onMouseDown );
	}
	
	function activate( e:UIEvent ) {
		postEvent( new ValueEvent<String>( TEXT_CHANGED, text ) );
		changed=false;
	}
	
	function textChanged( e:SimpleEvent ) {
		changed=true;
		if( text!=null ) {
			setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
		}
	}

	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged(attr);
		
		if( text!=null ) {
			setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
		}
	}

	override public function focus() :Bool {
		if( !super.focus() ) return false;
		textElement.focus(true);
		return true;
	}

	override public function blur() :Void {
		if( changed ) {
			postEvent( new ValueEvent<String>( TEXT_CHANGED, text ) );
			changed=false;
		}
		super.blur();
		textElement.focus(false);
	}
}
