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

import xinf.style.StyleClassElement;
import xinf.erno.Renderer;
import xinf.erno.FontStyle;

/**
    Simple Label element.
**/

class Label extends StyleClassElement {
	
    public var text(get_text,set_text):String;
    private var _text:String;
    
    public function new( ?text:String ) :Void {
		super();
		_text = text;
    }
    
    private function get_text() :String {
        return(_text);
    }
    
    private function set_text( t:String ) :String {
        _text = t;
		scheduleRedraw();
        return(t);
    }
	
	public function drawContents( g:Renderer ) :Void {
		super.drawContents(g);
	
		if( text == null ) return;
	
		var fontName = style.get("fontFamily","_sans");
		if( fontName != null ) {
			g.setFont( fontName, style.get("fontSlant",Roman),
					style.get("fontWeight",Normal),
					style.get("fontSize",12) );
		}

		if( style.background != null ) {
			g.setFill(style.background);
			g.setStroke( null, 0 );
			g.rect( 0, 0, size.x, size.y );
		}
		if( style.border.l > 0 ) {
			g.setFill(null);
			g.setStroke(style.color,style.border.l);
			g.rect( 0, 0, size.x, size.y );
		}
		
		g.setFill(style.color);
		g.text(style.padding.l+style.border.l,style.padding.t+style.border.t,text);
	}
	
}
