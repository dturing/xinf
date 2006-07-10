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

import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.geom.Point;
import xinf.event.Event;
import xinf.ony.Color;

import xinf.ony.MouseEvent;
import xinf.ony.ScrollEvent;
import xinf.ony.GeometryEvent;

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
        
        bg = new xinf.ony.Pane( name+"_background", this );
        bg.bounds.setSize( thumbSize, parent.bounds.height );
        bg.setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );
        bg.addEventListener( MouseEvent.MOUSE_DOWN, clickBar );
        
        thumb = new xinf.ony.Pane( name+"_thumb", this );
        thumb.bounds.setSize( thumbSize, thumbSize );
        thumb.setBackgroundColor( new Color().fromRGBInt( 0x999999 ) );
        thumb.addEventListener( MouseEvent.MOUSE_DOWN, clickThumb );

        parent.bounds.addEventListener( GeometryEvent.SIZE_CHANGED, parentSizeChanged );
        
        _move = move;
        _releaseThumb = releaseThumb;
    }

    public function parentSizeChanged( e:GeometryEvent ) {
//        bounds.setPosition( parent.bounds.width-thumbSize, 0 );
        bounds.setSize( thumbSize, parent.bounds.height );
        bg.bounds.setSize( thumbSize, parent.bounds.height );
    }

    public function clickBar( e:MouseEvent ) {
        var o = e.y - bounds.y;
        var delta:Int;
        if( o > thumb.bounds.y+thumb.bounds.height ) delta = 1;
        else if( o < thumb.bounds.y ) delta = -1;
        else return;
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_LEAP, this, delta ) );
    }
        
    public function clickThumb( e:MouseEvent ) {
        offset = e.y;
        var self=this;
        xinf.event.Global.addEventListener( MouseEvent.MOUSE_MOVE, _move );
        xinf.event.Global.addEventListener( MouseEvent.MOUSE_UP, _releaseThumb );
    }
    public function move( e:MouseEvent ) {
        var y:Float = (e.y - offset) + thumb.bounds.y;

        offset = e.y;
        if( y < 0 ) {
            offset -= y;
            y = 0;
        } else if( y > bounds.height-thumbSize ) {
            offset -= y-(bounds.height-thumbSize);
            y = bounds.height-thumbSize;
        }
        thumb.bounds.setPosition( 0, y );
        
        var value:Float = y/(bounds.height-thumbSize);
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_TO, this, value ) );
    }
    public function releaseThumb( e:MouseEvent ) {
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_MOVE, _move );
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_UP, _releaseThumb );
    }
    
    public function setScrollPosition( position:Float ) :Void {
        position = Math.max( 0, Math.min( 1, position ) );
        thumb.bounds.setPosition( 0, position * (bounds.height-thumbSize) );
    }
}
