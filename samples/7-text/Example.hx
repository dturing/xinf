/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 6: Text.
	
*/

class Example {
	
	public static function main() :Void {
		
		var text = new Text({
				x:150, y:100, fill:"black",
				fontSize: 20, fontFamily:"FreeSans",
				text:"textAnchor:start",
				textAnchor:"start",
			});
		Root.appendChild( text );

		var text = new Text({
				x:150, y:120, fill:"black",
				fontSize: 20, fontFamily:"FreeSans",
				text:"textAnchor:middle",
				textAnchor: "middle",
			});
		Root.appendChild( text );

		var text = new Text({
				x:150, y:140, fill:"black",
				fontSize: 20, fontFamily:"FreeSans",
				text:"textAnchor:end",
				textAnchor: "end",
			});
		Root.appendChild( text );

/*		
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			text.transform = new TransformList([
				new Scale( Math.sin(e.time/3)*3, Math.sin(e.time/3)*3 ),
				new Rotate( e.frame/300 ),
				new Translate( 400, 400 ),
			]);
		});
*/		
		Root.main();
		
	}
}

