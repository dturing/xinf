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
import xinf.erno.Color;
import xinf.erno.Runtime;
import xinf.ony.Application;
import xinf.ony.Rectangle;
import xinf.ony.Text;

class App extends Application {
	private static var block:Rectangle;
	private var center : { x:Float, y:Float };
	private var extend : { x:Float, y:Float };

	private static var hello:Text;

	public function new() :Void {
		super();

		block = new Rectangle( Color.WHITE );
		block.resize( 10, 10 );
		root.attach( block );
		
		center = { x:160., y:120. };
		extend = { x:80., y:30. };

		var s ="Xinf "+xinf.Version.version+"\n"
			  +"("+xinf.Version.built+")";
		
		if( xinf.Version.tagline!="" ) s+="\n"+xinf.Version.tagline;
		
		hello = new Text( s, Color.WHITE );
		root.attach( hello );
		
		Runtime.runtime.addEventListener( FrameEvent.ENTER_FRAME, onEnterFrame );
		Runtime.runtime.addEventListener( GeometryEvent.STAGE_SCALED, onStageScale );
	}
	
	public function onEnterFrame( e:FrameEvent ) :Void {
		var n = (e.frame/2);
		var w = 200;
		var h = 100;
		block.moveTo( 
			center.x + (Math.cos(n/2)*extend.x), 
			center.y + (Math.sin(n)*extend.y) );
	}
	
	public function onStageScale( e:GeometryEvent ) :Void {
		center = { x:(e.x/2)-5, y:(e.y/2)-20 };
		// TODO: xinf has no concept of text-widths currently, we cannot center text.
		hello.moveTo( (e.x/2)-80, (e.y/2)+30 );
	}

	public static function main() :Void {
		new App().run();
	}
}
