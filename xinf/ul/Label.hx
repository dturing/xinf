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
    public var autoSize:Bool;
    
    public function new( ?text:String ) :Void {
        super();
        this.text = text;
        autoSize = false;
    }
    
    function get_text() :String {
        return(_text);
    }
    
    function set_text( t:String ) :String {
        if( t != _text ) {
            _text = t;
            if( autoSize ) setPrefSize( getStyleTextFormat().textSize(t) );
            scheduleRedraw();
        }
        return(t);
    }

    override public function styleChanged( s:Style ) {
        var oldFont = getStyleTextFormat();
        super.styleChanged(s);
        var font = getStyleTextFormat();
        if( autoSize && text != null && font!=oldFont ) {
            setPrefSize( font.textSize(_text) );
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        setStyleFill( g, "color" );
        g.text( Math.round(leftOffsetAligned(prefSize.x,style.get("hAlign",0.))), topOffsetAligned(prefSize.y,style.get("vAlign",0.)), text, getStyleTextFormat() );
    }
}
