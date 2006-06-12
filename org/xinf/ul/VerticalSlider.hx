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

package org.xinf.ul;

import org.xinf.ony.Pane;
import org.xinf.ony.Element;
import org.xinf.geom.Point;
import org.xinf.event.Event;
import org.xinf.ony.Color;

/**
    Improvised Vertical Slider (Scrollbar) element.
**/

class VerticalSlider extends Pane {
    private static var thumbSize:Float = 12;

    private var thumb:Pane;
    private var offset:Float;
    private var _clickedMove:Dynamic;
    private var _unclickThumb:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        bounds.setSize( thumbSize, parent.bounds.height );
        bounds.setPosition( parent.bounds.width-thumbSize, 0 );
        trace("VSlider size: "+bounds );
        parent.bounds.addEventListener( Event.SIZE_CHANGED, parentSizeChanged );

        setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );
        
        thumb = new org.xinf.ony.Pane( name+"_thumb", this );
        thumb.bounds.setSize( thumbSize, thumbSize );
        thumb.setBackgroundColor( new Color().fromRGBInt( 0x999999 ) );
        
        thumb.addEventListener( Event.MOUSE_DOWN, clickThumb );
        
        _clickedMove = clickedMove;
        _unclickThumb = unclickThumb;
    }

    public function parentSizeChanged( e:Event ) {
        bounds.setSize( thumbSize, parent.bounds.height );
        bounds.setPosition( parent.bounds.width-thumbSize, 0 );
        trace("VSlider size: "+bounds );
    }
    
    public function clickThumb( e:Event ) {
        offset = e.data.y - thumb.bounds.y;
        var self=this;
        trace("clickThumb: "+e.data.y );
        org.xinf.event.EventDispatcher.addGlobalEventListener( Event.MOUSE_MOVE, _clickedMove );
        org.xinf.event.EventDispatcher.addGlobalEventListener( Event.MOUSE_UP, _unclickThumb );
    }
    public function clickedMove( e:Event ) {
        var y:Float = e.data.y - offset;
        if( y < 0 ) y = 0;
        else if( y > bounds.height-thumbSize ) y = bounds.height-thumbSize;
        thumb.bounds.setPosition( 0, y );
    }
    public function unclickThumb( e:Event ) {
        trace("unclick: "+e );
        org.xinf.event.EventDispatcher.removeGlobalEventListener( Event.MOUSE_MOVE, _clickedMove );
        org.xinf.event.EventDispatcher.removeGlobalEventListener( Event.MOUSE_UP, _unclickThumb );
    }
}
