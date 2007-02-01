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

import xinf.ony.Object;
import xinf.ul.Pane;
import xinf.event.Event;
import xinf.erno.Color;

import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;

/**
    Improvised Vertical Scrollbar element.
**/

class VScrollbar extends ComponentContainer {
    
    private var thumb:Pane;
    private var thumbHeight:Float;
    
    public function new() :Void {
        super();
        
        addEventListener( MouseEvent.MOUSE_DOWN, clickBar );
        
        thumb = new xinf.ul.Pane();
        thumb.addStyleClass("Thumb");
        thumb.addEventListener( MouseEvent.MOUSE_DOWN, clickThumb );
        thumb.resize(12,12);
        attach(thumb);
        
        thumbHeight = thumb.size.y;
        
        size={x:12.,y:20.};
    }

    public function clickBar( e:MouseEvent ) {
        var y = globalToLocal( { x:1.*e.x, y:1.*e.y }).y;
        
        var delta:Int;
        if( y > thumb.position.y+thumb.size.y ) delta = 1;
        else if( y < thumb.position.y ) delta = -1;
        else return;
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_LEAP, delta ) );
    }
        
    public function clickThumb( e:MouseEvent ) {
        new Drag<Float>( e, move, null, thumb.position.y );
    }
    
    public function move( x:Float, y:Float, marker:Float ) {
        var y:Float = marker+y;
        if( y < 0 ) {
            y = 0;
        } else if( y > size.y-thumbHeight ) {
            y = size.y-thumbHeight;
        }
        thumb.position.y = Math.floor(y);
        
        var value:Float = y/(size.y-thumbHeight);
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_TO, value ) );
        
        thumb.scheduleRedraw();
    }
    
    public function setScrollPosition( position:Float ) :Void {
        position = Math.max( 0, Math.min( 1, position ) );
        thumb.position.y = Math.floor(position * (size.y-thumbHeight));
        thumb.scheduleRedraw();
    }
    
}
