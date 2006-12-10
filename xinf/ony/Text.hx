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
import xinf.erno.DrawingInstruction;
import xinf.erno.Color;

class Text extends Object {
	public var color:Color;
	public var font:DrawingInstruction;
	public var text:String;

	public function new( ?text:String, ?font:DrawingInstruction, ?color:Color ) :Void {
		if( color==null ) color = Color.BLACK;
		if( font==null )  font = SetFont( "_sans", Roman, Normal, 12 );
		this.color=color;
		this.font=font;
		this.text=text;
		super();
	}
	
	public function drawContents( g:Renderer ) :Void {
		if( text!=null ) {
			g.draw( SetFill(color) );
			g.draw( font );
			g.draw( Text(text) );
		}
//		g.draw( Rect( position.x, position.y, size.x, size.y ) );
	}
}
