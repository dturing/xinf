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

package xinf.erno;

import xinf.erno.DrawingInstruction;
import xinf.event.FrameEvent;

import xinf.erno.Runtime;
import xinf.erno.Renderer;
import xinf.erno.Color;

class Test {
	public static function main() :Void {
		Runtime.init();
		var g:Renderer = Runtime.renderer;
		
		var squares = g.getNextId();
		var text = g.getNextId();
		var shape = g.getNextId();
		var animInner = g.getNextId();
		var animOuter = g.getNextId();
		
		g.drawList( [
				StartObject(squares),
					Translate(10,10),
					SetFill( Color.RED ),
					Rect( 0, 0, 50, 50),
					SetFill( Color.GREEN ),
					Rect( 50, 0, 50, 50),
					SetFill( Color.BLUE ),
					Rect( 100, 0, 50, 50),
				EndObject,
				
				StartObject(text),
					SetFill( Color.BLACK ),
					SetFont( "Bitstream Vera Sans", Roman, Normal, 16 ),
					
					Translate(10,60),
					Text("Hello, World!"),
				EndObject,
				
				StartObject(shape),
					SetFill( Color.WHITE ),
					SetStroke( Color.BLACK, 1 ),
					Translate( 0, 200 ),
					Scale( 2, 2 ),
					StartShape,
						StartPath( 10, 10 ),
							LineTo( 20, 10 ),
							QuadraticTo( 30, 0, 40, 10 ),
							LineTo( 60, 10 ),
							CubicTo( [ 70., 0, 90, 20, 100, 10 ] ),
							LineTo( 110, 10 ),
							LineTo( 110, 20 ),
							LineTo( 10, 20 ),
							Close,
						EndPath,
						StartPath( 15, 15 ),
							LineTo( 105, 15 ),
							LineTo( 105, 25 ),
							LineTo( 15, 25 ),
							Close,
						EndPath,
					EndShape,
					
				EndObject,				
				
				StartObject(animInner),
					SetFill( Color.WHITE ),
					Rect(0,0,10,10),
				EndObject,
				StartObject(animOuter),
					Translate(10,100),
					ShowObject(animInner),
				EndObject,

				StartObject(g.getRootId()),
					ShowObject(squares),
					ShowObject(shape),
					ShowObject(text),
					ShowObject(animOuter),
				EndObject
			].iterator() );
			
		Runtime.runtime.addEventFilter( function(e:Dynamic):Bool {
			if( e.type != FrameEvent.ENTER_FRAME ) trace("Event: "+e);
			return true;
		} );
			
		Runtime.addEventListener( FrameEvent.ENTER_FRAME,
			function( e:FrameEvent ) :Void {
				g.drawList( [
					StartObject(animOuter),
						Translate(80+( Math.sin(e.frame/6.)*70 ), 140 + ( Math.sin(e.frame/3)*30 ) ),
						ShowObject(animInner),
					EndObject,
					ShowObject(g.getRootId())
				].iterator() );
				Runtime.runtime.changed();
			} );
			
		Runtime.run();
		
	}
}