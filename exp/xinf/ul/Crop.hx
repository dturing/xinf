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
import xinf.style.StyleClassElement;

/**
    Simple Cropping container element.
**/

class Crop extends Container {
    
    public function new() :Void {
        super();
    }
            
    override public function drawChildren( g:xinf.erno.Renderer ) :Void {
        /* debug 
            g.setFill(0,0,0,0);
            g.setStroke(1,0,0,1,1);
            g.rect( 0, 0, size.x, size.y );
            */
        
        g.clipRect( size.x, size.y );
        super.drawChildren(g);
    }
    
    #if neko
    /*
        i dont know how else to do this, glScissors need to update their global position whenever
        parent transforms change...
        really, use glClip-- but doesnt work on a r300 (my testing machine)
        so, FIXME, once that works...
        
        -- only for glScissors, see GLRenderer's clipRect()
    override public function transformChanged() :Void {
        scheduleRedraw();
    }
    */
    #end
}
