/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.Component;
import xinf.ul.layout.Helper;

/**
    Simple Label element.
**/

class Label extends Component {
    
    public var text(get_text,set_text):String;
	var textElement:Text;
    
    public function new( ?text:String, ?traits:Dynamic ) :Void {
		textElement = new Text();
		super( traits );
		group.appendChild( textElement );
        if( text!=null ) this.text = text;
    }
    
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
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 )+fontSize;
		textElement.x = Helper.leftOffsetAligned( this, s.x, .5 );
		return super.set_size(s);
	}

    override public function styleChanged( ?attr:String ) {
		super.styleChanged( attr );
		
		textElement.fontSize = fontSize;
		textElement.fontFamily = fontFamily;
		textElement.fill = textColor;
		textElement.styleChanged();
		
		// TODO: fontWeight
		if( text!=null ) {
			setPrefSize( Helper.addPadding( getTextFormat().textSize(text), this ) );
		}
    }
}
