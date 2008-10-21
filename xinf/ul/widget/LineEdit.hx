/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.layout.Helper;
import xinf.ony.type.Editability;
import xinf.ul.ValueEvent;

typedef TString = 
#if flash
	Dynamic
#else
	String
#end

class LineEdit extends ValueWidget<TString> {

	public static var TEXT_CHANGED = new xinf.event.EventKind<ValueEvent<String>>("textChanged");
	
	private var textElement:TextArea;
	var changed:Bool;
	
	override function get_value() :TString {
		return textElement.text;
	}
/*

	override function set_value(t:TString) :TString {
		textElement.text = t;
		return setValueInternal(t);
	}
	*/
	
	function setValueInternal(t:String) :String {
		changed = true;
		setPrefSize( Helper.addPadding( getTextFormat().textSize(t), this ) );
		return super.set_value(t);
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

	public function new( initialValue:String, ?traits:Dynamic ) :Void {
		textElement = new TextArea();
		super( traits );
		changed=false;

		textElement.editable = Editability.Simple;
		textElement.text = initialValue;
		group.appendChild( textElement );
		
		textElement.addEventListener( SimpleEvent.CHANGED, textChanged );
		textElement.addEventListener( UIEvent.ACTIVATE, activate );
	}
	
	function activate( e:UIEvent ) {
		textChanged(e);
		postEvent( new ValueEvent<String>( TEXT_CHANGED, value ) );
	}
	
	function textChanged( e:Dynamic ) {
		setValueInternal( textElement.text );
	}

	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged(attr);
		
		if( value!=null ) {
			setPrefSize( Helper.addPadding( getTextFormat().textSize(value), this ) );
		}
	}

	override public function focus() :Bool {
		if( !super.focus() ) return false;
		textElement.focus(true);
		return true;
	}

	override public function blur() :Void {
		if( changed ) {
			postEvent( new ValueEvent<String>( TEXT_CHANGED, value ) );
			changed=false;
		}
		super.blur();
		textElement.focus(false);
	}
}
