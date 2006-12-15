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

package xinf.ony;

import xinf.erno.Renderer;
import xinf.erno.Color;

class Rectangle extends Object {
	private var color:Color;

	public function new( ?color:Color ) :Void {
		this.color=color;
		super();
	}
	
	public function drawContents( g:Renderer ) :Void {
		g.setFill(color);
		g.rect( 0, 0, size.x, size.y );
	}
}
