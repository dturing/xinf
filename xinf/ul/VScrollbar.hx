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
import xinf.ul.Button;

import xinf.ony.MouseEvent;
import xinf.ony.ScrollEvent;
import xinf.ony.GeometryEvent;

/**
    Improvised Vertical Scrollbar element.
**/

class VScrollbar extends xinf.style.StyleClassElement {
    private static var thumbWidth:Float = 11;

    private var thumb:Pane;
	private var thumbHeight:Float;
    private var offset:Float;
    private var _move:Dynamic;
    private var _releaseThumb:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
		thumbHeight = 16;
		
        bounds.setPosition( (parent.bounds.width-thumbWidth), 0 );
        bounds.setSize( thumbWidth, parent.bounds.height );
        
        addEventListener( MouseEvent.MOUSE_DOWN, clickBar );
        
        thumb = new xinf.ul.ImageButton( name+"_thumb", this, "assets/vscrollbar/thumb/center.png" );
        thumb.bounds.setSize( thumbWidth, thumbHeight );
        thumb.setBackgroundColor( new Color().fromRGBInt( 0x999999 ) );
        thumb.addEventListener( MouseEvent.MOUSE_DOWN, clickThumb );
		thumb.autoSize = false;

        parent.bounds.addEventListener( GeometryEvent.SIZE_CHANGED, parentSizeChanged );
        
        _move = move;
        _releaseThumb = releaseThumb;
		updateStyles();
    }

    public function parentSizeChanged( e:GeometryEvent ) {
        bounds.setSize( thumbWidth, parent.bounds.height-2 );
    }

    public function clickBar( e:MouseEvent ) {
		if( e.target != this ) return;
		
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
        } else if( y > bounds.height-thumbHeight ) {
            offset -= y-(bounds.height-thumbHeight);
            y = bounds.height-thumbHeight;
        }
        thumb.bounds.setPosition( 0, Math.floor(y) );
        
        var value:Float = y/(bounds.height-thumbHeight);
		postEvent( new ScrollEvent( ScrollEvent.SCROLL_TO, this, value ) );
    }
    public function releaseThumb( e:MouseEvent ) {
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_MOVE, _move );
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_UP, _releaseThumb );
    }
    
    public function setScrollPosition( position:Float ) :Void {
        position = Math.max( 0, Math.min( 1, position ) );
        thumb.bounds.setPosition( 0, Math.floor(position * (bounds.height-thumbHeight)) );
    }
}
