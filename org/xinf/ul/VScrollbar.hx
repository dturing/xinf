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
    Improvised Vertical Scrollbar element.
**/

class VScrollbar extends Pane {
    private static var thumbSize:Float = 12;

    private var thumb:Pane;
    private var bg:Pane;
    private var offset:Float;
    private var _move:Dynamic;
    private var _releaseThumb:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        bounds.setPosition( parent.bounds.width-thumbSize, 0 );
        bounds.setSize( thumbSize, parent.bounds.height );
        
        bg = new org.xinf.ony.Pane( name+"_background", this );
        bg.bounds.setSize( thumbSize, parent.bounds.height );
        bg.setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );
        bg.addEventListener( Event.MOUSE_DOWN, clickBar );
        
        thumb = new org.xinf.ony.Pane( name+"_thumb", this );
        thumb.bounds.setSize( thumbSize, thumbSize );
        thumb.setBackgroundColor( new Color().fromRGBInt( 0x999999 ) );
        thumb.addEventListener( Event.MOUSE_DOWN, clickThumb );

        parent.bounds.addEventListener( Event.SIZE_CHANGED, parentSizeChanged );
        
        _move = move;
        _releaseThumb = releaseThumb;
    }

    public function parentSizeChanged( e:Event ) {
//        bounds.setPosition( parent.bounds.width-thumbSize, 0 );
        bounds.setSize( thumbSize, parent.bounds.height );
        bg.bounds.setSize( thumbSize, parent.bounds.height );
    }

    public function clickBar( e:Event ) {
        var o = e.data.y - bounds.y;
        if( o > thumb.bounds.y+thumb.bounds.height ) step( true );
        else if( o < thumb.bounds.y ) step( false );
    }
    
    public function step( down:Bool ) {
        var y:Float = thumb.bounds.y;
        if( down ) {
            y += thumbSize;
            if( y > bounds.height-thumbSize ) y = bounds.height-thumbSize;
        } else {
            y -= thumbSize;
            if( y < 0 ) y = 0;
        }
        thumb.bounds.setPosition( 0, y );
    }
    
    public function clickThumb( e:Event ) {
        var p:Point = thumb.localToGlobal( new Point( e.data.x, e.data.y ) );
        offset = p.y;
        var self=this;
        org.xinf.event.EventDispatcher.addGlobalEventListener( Event.MOUSE_MOVE, _move );
        org.xinf.event.EventDispatcher.addGlobalEventListener( Event.MOUSE_UP, _releaseThumb );
    }
    public function move( e:Event ) {
        var y:Float = (e.data.y - offset) + thumb.bounds.y;

        offset = e.data.y;
        if( y < 0 ) {
            offset -= y;
            y = 0;
        } else if( y > bounds.height-thumbSize ) {
            offset -= y-(bounds.height-thumbSize);
            y = bounds.height-thumbSize;
        }
        thumb.bounds.setPosition( 0, y );
        
        var value:Float = y/(bounds.height-thumbSize);
        postEvent( Event.SCROLLED, { value:value } );
    }
    public function releaseThumb( e:Event ) {
        org.xinf.event.EventDispatcher.removeGlobalEventListener( Event.MOUSE_MOVE, _move );
        org.xinf.event.EventDispatcher.removeGlobalEventListener( Event.MOUSE_UP, _releaseThumb );
    }
}
