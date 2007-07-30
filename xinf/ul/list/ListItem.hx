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

package xinf.ul.list;

import xinf.erno.Renderer;
import xinf.ul.Label;
import xinf.ul.Container;
import xinf.ul.model.ISettable;

class ListItem<T> extends Label, implements ISettable<T> {
    
    var cursor:Bool;
    
    public function setCursor( isCursor:Bool ) :Bool {
        if( isCursor!=cursor ) {
            cursor = isCursor;
            scheduleRedraw();
        }
        return cursor;
    }
    
    var value:T;
    
    public function new( ?value:T ) :Void {
        super( ""+value );
        this.value = value;
        cursor=false;
        autoSize=false;
    }
    
    public function set( ?value:T ) :Void {
        this.value = value;
        this.text = if( value==null ) "" else ""+value;
    }
    
    public function attachTo( parent:Container ) :Void {
        parent.attach(this);
    }
    
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( cursor ) {
            setStyleFill( g, "cursorColor" );
            var cs = style.get("cursorSize",3);
            g.rect( -cs, 0, cs, size.y ); 
        }
        setStyleFill( g, "color" );
        g.text( Math.round(leftOffsetAligned(prefSize.x,style.get("hAlign",0.))), topOffsetAligned(prefSize.y,style.get("vAlign",0.)), text, getStyleTextFormat() );
    }
}
