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

import xinf.erno.DrawingInstruction;
import xinf.erno.Renderer;
import xinf.erno.Coord2d;
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
    
	public function drawContents( g:Renderer ) :Void {
		g.draw( Translate( position.x, position.y ) );
		if( crop )
			g.draw( ClipRect( size.x-2, size.y-2 ) );
			
		g.draw( SetFill(style.background) );
		g.draw( SetStroke( null, 0 ) );
		g.draw( Rect( 0, 0, size.x, size.y ) );
		
		if( style.border.l > 0 ) {
			g.draw( SetFill(null) );
			g.draw( SetStroke(style.color,style.border.l) );
			g.draw( Rect( 0, 0, size.x, size.y ) );
		}
	}
}
