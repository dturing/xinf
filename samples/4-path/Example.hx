import Xinf;
import xinf.ony.type.PathSegment;

/**
	Example 4: Path segments.
	
	This example demonstrates how to construct a simple path
	containing one segment of each possible type.
*/

class Example {
	
	public static function main() :Void {

		var path = new Path({ stroke:"red", stroke_width:2 });
		
		var segments = new List<PathSegment>();
		segments.add( MoveTo( 50, 50 ) );
		segments.add( LineTo( 100, 50 ) );
		segments.add( CubicTo( 110, 25, 140, 75, 150, 50 ) );
		segments.add( QuadraticTo( 175, 25, 200, 50 ) );

		// TODO, not yet fully supported
		/*
		segments.add( Close );
		segments.add( ArcTo( ... ) );
		*/
		
		path.segments = segments;
		
		Root.appendChild( path );

		/* Pass control to the xinf main loop */
		Root.main();
		
	}
}
