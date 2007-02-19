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
    Simple Pane element.
**/

class Pane extends Container {
    
    public function new() :Void {
        super();
    }

    override public function draw( g:Renderer ) :Void {
        g.startObject( _id );
            var skin:xinf.style.Skin = style.get("skin",null);
            if( skin!=null ) {
                skin.drawBackground( g, size, style.border );
            } else {
                setStyleFill( g, "background" );
                g.setStroke( 0,0,0,0,0 );
                g.rect( 0, 0, size.x, size.y );
                
                g.setFill(0,0,0,0);
                setStyleStroke( g, style.border.l, "color" );
                g.rect( 0, 0, size.x, size.y );
            }
            drawContents(g);
            drawChildren(g);
            if( skin!=null ) {
                skin.drawBorder( g, size, style.border );
            }
        g.endObject();
        reTransform(g);
    }
    
}
