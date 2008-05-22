/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 5: Events
	
	This example demonstrates some simple UI events
	(mouse, keyboard, enterFrame, stageScaled).
	
	Note that all events are triggered on Root,
	except mouseDown/Over/Out, which are triggered on
	the Element that covers the current mouse position.
*/

class Example {
	
	public static function main() :Void {
		
		var rect = new Rectangle({ x:10, y:10, width:100, height:100, fill:"red" });
		Root.appendChild( rect );

		rect.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		
		rect.addEventListener( MouseEvent.MOUSE_OVER, reportEvent );
		rect.addEventListener( MouseEvent.MOUSE_OUT, reportEvent );
		
		Root.addEventListener( MouseEvent.MOUSE_UP, reportEvent );
		Root.addEventListener( MouseEvent.MOUSE_MOVE, reportEvent );

		Root.addEventListener( KeyboardEvent.KEY_DOWN, reportEvent );
		Root.addEventListener( KeyboardEvent.KEY_UP, reportEvent );

		Root.addEventListener( GeometryEvent.STAGE_SCALED, reportEvent );

		/* of course, you can also pass a function directly: */
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e:FrameEvent) {
			if( e.frame % 100 == 0 ) trace("frame #"+e.frame);
		});

		Root.main();
		
	}
	
	static function onMouseDown( e:MouseEvent ) {
		trace("Mouse button "+e.button+" pressed at ("+e.x+","+e.y+")");
	}
	
	/*
		In this example, all events (except mouseDown) are reported 
		via this function, which takes "Dynamic". 
		In reality, you should correctly type your handler, 
		like demonstrated with the mouseDown function.
	*/
	static function reportEvent( e:Dynamic ) {
		trace("Event: "+e );
	}
}
