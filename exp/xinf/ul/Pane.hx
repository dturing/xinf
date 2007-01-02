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

class Pane extends StyleClassElement {
    
    public var crop:Bool;
    
    public function new() :Void {
        super();
        crop=false;
    }
    
    public function resize( x:Float, y:Float ) :Void {
        // TODO: layouters need to know size. do this differently.
        var w = Math.max( style.get("minWidth",0), x );
        var h = Math.max( style.get("minHeight",0), y );
        super.resize(w,h);
    }
        
    public function drawContents( g:Renderer ) :Void {
        if( crop )
            g.clipRect( size.x, size.y );

        // FIXME: code doubled from ul.Label
        if( style.background != null ) {
            g.setFill( style.background.r, style.background.g, style.background.b, style.background.a );
            g.setStroke( 0,0,0,0,0 );
            g.rect( 0, 0, size.x, size.y );
        }
        if( style.border.l > 0 ) {
            g.setFill(0,0,0,0);
            g.setStroke(style.color.r,style.color.g,style.color.b,style.color.a,style.border.l);
            g.rect( 0, 0, size.x, size.y );
        } 
     }
}
