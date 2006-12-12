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

import xinf.event.FrameEvent;
import xinf.event.GeometryEvent;
import xinf.erno.Renderer;
import xinf.ony.Application;
import xinf.ony.Object;

#if flash
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	typedef Primitive = DisplayObject
#else err
#end

class Native extends Object {
	private var p:Primitive;

	public function new( p:Primitive ) :Void {
		super();
		this.p=p;
	}
	
	public function drawContents( g:Renderer ) :Void {
		if( p!=null )
			g.native(p);
	}
}


class App extends Application {
	private static var block:Object;

	public function new() :Void {
		super();
		
		var p:Primitive;
		
		#if flash
			var s = new Sprite();
			p=s;
			s.graphics.beginFill( 0xff0000, 1 );
			s.graphics.moveTo( 10, 10 );
			s.graphics.lineTo( 100, 10 );
			s.graphics.lineTo( 10, 100 );
			s.graphics.endFill();
		#end

		block = new Native(p);
		root.attach( block );
	}

	public static function main() :Void {
		new App().run();
	}
}
