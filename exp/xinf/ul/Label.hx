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
import xinf.erno.FontStyle;

/**
    Simple Label element.
**/

class Label extends Pane {
    
    public var text(get_text,set_text):String;
    var _text:String;
    var textSize:{x:Float,y:Float};
    
    public function new( ?text:String ) :Void {
        super();
        _text = text;
        textSize = {x:0,y:0};
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
        if( w!=textSize.x || h!=textSize.y ) {
        trace("text size of label "+text+" changed from "+textSize+" to w "+w );
            textSize = { x:w, y:h };
            resizeInner( w, h );
            //resize(w,h);
            postResizeEvent();
        }
    }
    
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
    
        setStyleFont( g );
        setStyleFill( g, "color" );
        g.text(innerPos.x,innerPos.y,text,onTextSizeChanged);
    }
}
