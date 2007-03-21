/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.style;

import xinf.erno.Renderer;

class Skin {
    var border:Fill;
    var bg:Fill;
    var fg:Fill;
    
    public function new( ?border:Fill, ?background:Fill, ?foreground:Fill ) {
        this.border = border;
        bg = background;
        fg = foreground;
    }
    
    public function drawBackground( g:Renderer, size:{x:Float,y:Float} ) :Void {
        if( bg!=null ) bg.draw( g, size );
    }
    
    public function drawForeground( g:Renderer, size:{x:Float,y:Float} ) :Void {
        if( fg!=null ) fg.draw( g, size );
        if( border!=null ) border.draw( g, size );
    }
}
