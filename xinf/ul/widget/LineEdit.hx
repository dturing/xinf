/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.layout.Helper;
import xinf.ony.type.Editability;

class LineEdit extends Widget {
    public var text(get_text,set_text) :String;
    private var textElement:TextArea;

    private function get_text() :String {
        return textElement.text;
    }
    
    private function set_text(t:String) :String {
        textElement.text = t;
		setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
        return t;
    }

	override public function set_size( s:TPoint ) :TPoint {
		// FIXME: text-anchor center, set center here.
		var s2 = Helper.removePadding( s, this );
		textElement.width = s2.x;
		textElement.height = s2.y;
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
		
//		addEventListener( KeyboardEvent.KEY_DOWN, textElement.onKeyDown );
//		group.addEventListener( MouseEvent.MOUSE_DOWN, textElement.onMouseDown );
	}

	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged(attr);
		
		textElement.fontSize = fontSize;
		textElement.fontFamily = fontFamily;
		// TODO: fontWeight
		textElement.fill = textColor;
		textElement.styleChanged();
		/*
		if( size!=null ) set_size(size);
		*/
		
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
		super.blur();
		textElement.focus(false);
    }
}
