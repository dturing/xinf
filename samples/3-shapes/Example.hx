import Xinf;

/**
	Example 3: Other Shapes.
	
	This example demonstrates the simple SVG shapes 
	that are not presented in any other example.
*/

class Example {
	
	public static function main() :Void {

		var circle = new Circle({
							cx:50., cy:50., 	// center
							r:50.,				// radius
							fill:"red" });
		Root.appendChild( circle );


		var ellipse = new Ellipse({
							cx:150., cy:50., 	// center
							rx:30., ry:40,		// radii
							fill:"red" });
		Root.appendChild( ellipse );


		var line = new Line({
							x1:200., y1:0.,		// first point
							x2:300., y2:100.,	// second point
							stroke:"red", stroke_width:2 });
		Root.appendChild( line );


		/* the difference between a Polyline and a Polygon is
		   that a Polygon is always closed. */

		var polyline = new Polyline({ stroke:"red", stroke_width:2, fill:"green" });
		polyline.points = [ { x:0., y:100. },
							{ x:80., y:120. },
							{ x:100., y:200. } ];
		Root.appendChild( polyline );


		var polygon = new Polygon({ stroke:"red", stroke_width:2, fill:"green" });
		polygon.points = [ { x:100., y:100. },
							{ x:180., y:120. },
							{ x:200., y:200. } ];
		Root.appendChild( polygon );


		/* Pass control to the xinf main loop */
		Root.main();
		
	}
}
