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

class Native extends Object {
	private var p:NativeObject;

	public function new( p:NativeObject ) :Void {
		super();
		this.p=p;
	}
	
	public function drawContents( g:Renderer ) :Void {
		if( p!=null ) {
			g.native(p);
		}
	}
}


class App extends Application {
	private static var block:Object;

	public function new() :Void {
		super();
		
		var p:NativeObject = null;
		
		#if flash
			var s = new flash.display.Sprite();
			s.graphics.beginFill( 0xff0000, 1 );
			s.graphics.moveTo( 10, 10 );
			s.graphics.lineTo( 100, 10 );
			s.graphics.lineTo( 10, 100 );
			s.graphics.endFill();
			p=s;
		#else js
			var div = js.Lib.document.createElement("div");
			div.innerHTML="this is <b onmousedown=\"this.innerHTML = 'clicked'\">native</b> html";
			p=div;
		#else true
		#end

		block = new Native(p);
		block.moveTo( 100, 100 );
		root.attach( block );
	}

	public static function main() :Void {
		new App().run();
	}
}
