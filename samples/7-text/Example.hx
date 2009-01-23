/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 6: Text.
	
*/

class Example {
	
	public static function main() :Void {
		
		var g = new Group({
//				fontFamily:"Blue Highway D Type"
			});
		Root.appendChild(g);
			
		var text = new Text({
				x:150, y:100, fill:"black",
				fontSize: 100,
				text:"Hello World!",
				textAnchor:"start",
			});
		g.appendChild( text );
		
		var textArea = new TextArea({
				x:100, y:100, fill:"black",
				width:300, height:200,
				fontSize:40,
				text:"default!",
				editable:"simple",
			});
		g.appendChild( textArea );
		
		/*
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
*/
/*
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			text.transform = 
//				new TransformList([
				new Rotate( Math.PI*.1*Math.sin(e.time), 300, 240 );
//				new Scale( 1+(Math.sin(e.time)*.14), 1+(Math.sin(e.time)*.14), 300, 240 )
//				]);
			text.fontSize = 150+((Math.sin(e.time)*140));
			text.x = 150-(Math.sin(e.time)*150);
		
		});
		*/
		Root.main();
		
	}
}

