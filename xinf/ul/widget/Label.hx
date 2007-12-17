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
import xinf.ul.Container;
import xinf.ul.layout.Helper;
import xinf.erno.Paint;

/**
    Simple Label element.
**/

class Label extends Container {
    
    public var text(get_text,set_text):String;
	var textElement:Text;
    
    public function new( ?text:String ) :Void {
		textElement = new Text();
        super();
		group.attach( textElement );
        this.text = text;
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
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 );
		textElement.x = Helper.leftOffsetAligned( this, s.x, .5 );
		return super.set_size(s);
	}

    override public function styleChanged() {
		super.styleChanged();
		
		textElement.style.fontSize = style.fontSize;
		textElement.style.fontFamily = style.fontFamily;
		//hmm?
		textElement.style.fill = SolidColor(.9,.4,.9,.9);//style.textColor;
		textElement.styleChanged();
		
		// TODO: fontWeight
		if( text!=null ) {
			setPrefSize( Helper.addPadding( style.getTextFormat().textSize(text), style ) );
		}
    }
}
