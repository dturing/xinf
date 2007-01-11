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

class Label extends Pane {
    
    public var text(get_text,set_text):String;
    private var _text:String;
    
    function new( ?text:String ) :Void {
        super();
        _text = text;
    }
    
    function get_text() :String {
        return(_text);
    }
    
    function set_text( t:String ) :String {
        _text = t;
        scheduleRedraw();
        return(t);
    }
    
    function onTextSizeChanged( w:Float, h:Float ) :Void {
        if( w!=size.x || h!=size.y ) resize(w,h);
    }
    
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
    
        setStyleFont( g );
        setStyleFill( g, "color" );
        g.text(style.padding.l+style.border.l,style.padding.t+style.border.t,text,onTextSizeChanged);
    }
}
