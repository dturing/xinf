import Xinf;
import xinf.ony.type.PathSegment;

/**
	Example 4: Path segments.
	
	This example demonstrates 
*/

class Example {
	
	public static function main() :Void {

		var path = new Path({ stroke:"red", stroke_width:2 });
		
		path.segments = [
				MoveTo( 50, 50 ),
				LineTo( 100, 50 ),
				CubicTo( 110, 25, 140, 75, 150, 50 ),
				QuadraticTo( 175, 25, 200, 50 ),
				
			];
		
		Root.appendChild( path );

		/* Pass control to the xinf main loop */
		Root.main();
		
	}
}
