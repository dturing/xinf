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

import xinf.erno.Renderer;
import xinf.style.Style;

/**
    Simple Label element.
**/

class Label extends Pane {
    
    public var text(get_text,set_text):String;
    var _text:String;
    
    public function new( ?text:String ) :Void {
        super();
        this.text = text;
    }
    
    function get_text() :String {
        return(_text);
    }
    
    function set_text( t:String ) :String {
        if( t != _text ) {
            _text = t;
            var s = getStyleTextFormat().textSize(t);
            preferredSize.width.value = s.x;
            preferredSize.height.value = s.y;
            scheduleRedraw();
        }
        return(t);
    }

    override public function applyStyle( s:Style ) {
        var oldFont = getStyleTextFormat();
        super.applyStyle(s);
        var font = getStyleTextFormat();
        if( text != null && font!=oldFont ) {
            var s = font.textSize(_text);
            preferredSize.width.value = s.x;
            preferredSize.height.value = s.y;
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
    
        setStyleFill( g, "color" );
        g.text(innerPos.x,innerPos.y,text,getStyleTextFormat());
    }
}
