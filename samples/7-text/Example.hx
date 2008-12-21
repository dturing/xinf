/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 6: Text.
	
*/

class Example {
	
	public static function main() :Void {
		
		var text = new Text({
				x:0, y:0, fill:"black",
				text:"Hello, World!",
				fontSize: 56, fontFamily:"FreeSans"
			});
		Root.appendChild( text );
		
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			text.transform = new TransformList([
				new Scale( Math.sin(e.time/3)*3, Math.sin(e.time/3)*3 ),
				new Rotate( e.frame/300 ),
				new Translate( 400, 400 ),
			]);
		});
		
		Root.main();
		
	}
}

