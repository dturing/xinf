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

package org.xinf.ony;

/**
    A Pane is a xinfony Element that renders a rectangle in its background color.
    Pane can be useful by itself, but is also base class for other visible Elements
    that can have a background.
**/
class Pane extends Element {
    private var bgColor:org.xinf.ony.Color;

    /** Constructor. **/
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        
        #if js
            _p.style.overflow = "visible";
        #end

        setBackgroundColor( new org.xinf.ony.Color() );
    }
    
    private function createPrimitive() :Dynamic {
        #if neko
            return new org.xinf.inity.Box();
        #else js
            return js.Lib.document.createElement("div");
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
        #end
    }
    
    /** Set the background color to the Color specified. **/
    public function setBackgroundColor( bg:org.xinf.ony.Color ) :Void {
        bgColor = bg;
        
        #if neko
            _p.bgColor = bgColor;
            _p.changed();
        #else js
            _p.style.background = bgColor.toRGBString();
        #else flash
            scheduleRedraw();
        #end
    }
    
    #if flash
        private function redraw() :Void {
            super.redraw();

            var x:Int = 0;
            var y:Int = 0;
            var w:Int = Math.round(bounds.width);
            var h:Int = Math.round(bounds.height);

            _p.clear();
            _p.beginFill( bgColor.toRGBInt(),  100 );

    //            _p.lineStyle( style.borderWidth, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );

            _p.moveTo( x, y );
            _p.lineTo( w, y );
            _p.lineTo( w, h );
            _p.lineTo( x, h );
            _p.lineTo( x, y );
            _p.endFill();
        }
    #end
}
