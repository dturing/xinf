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
import xinf.erno.FontStyle;

class Text extends Object {
	
	public var color:Color;
	public var text:String;

	public function new( ?text:String, ?color:Color ) :Void {
		if( color==null ) color = Color.BLACK;
		this.color=color;
		this.text=text;
		super();
	}
	
	public function drawContents( g:Renderer ) :Void {
		if( text!=null ) {
			g.setFill(color);
			g.setFont( "_sans", Roman, Normal, 12 );
			g.text(0,0,text);
		}
	}
	
}
