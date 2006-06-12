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
    Testing Element. Displays position of mouseMove events.
**/

class MouseMonitor extends Pane {
    private var pointer:Pane;
    private var info:org.xinf.ony.Text;
    private var info2:org.xinf.ony.Text;
    
    private var __mouseMove:Dynamic;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );

        addEventListener( Event.MOUSE_OVER, mouseOver );
        addEventListener( Event.MOUSE_OUT, mouseOut );
        
        info = new org.xinf.ony.Text( name+"_info", this );
        info.bounds.setPosition( 10, 10 );
        info.setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );
        info.setTextColor( new Color().fromRGBInt( 0 ) );
        info2 = new org.xinf.ony.Text( name+"_info2", this );
        info2.bounds.setPosition( 10, 30 );
        info2.setBackgroundColor( new Color().fromRGBInt( 0xdddddd ) );
        info2.setTextColor( new Color().fromRGBInt( 0 ) );

        pointer = new org.xinf.ony.Pane( name+"_pointer", this );
        pointer.bounds.setSize( 10, 10 );
        pointer.setBackgroundColor( new Color().fromRGBInt( 0xffaaaa ) );

        this.__mouseMove = mouseMove;
    }

    public function mouseMove( e:Event ) {
        pointer.bounds.setPosition( e.data.x - 11, e.data.y - 11 );
        info.text = ""+e.data.x+"/"+e.data.y;
    }

    public function mouseOver( e:Event ) {
        info2.text = "over";
        addEventListener( Event.MOUSE_MOVE, this.__mouseMove );
    }

    public function mouseOut( e:Event ) {
        info2.text = "out";
        removeEventListener( Event.MOUSE_MOVE, this.__mouseMove );
    }
}
