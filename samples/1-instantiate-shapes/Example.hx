import Xinf;

/**
	Example 1: Instantiating Shapes.
	
	This example demonstrates the basic ways to instantiate shapes,
	attach them to Root, and pass control to the xinf main loop.
*/

class Example {
	
	public static function main() :Void {
		
		/* Create a Rectangle, set it's position, size and fill color, 
		   and attach it to the Root singleton. */
		   
		var firstRect = new Rectangle();
		firstRect.x = 10; 
		firstRect.y = 10; 
		firstRect.width = 100;
		firstRect.height = 100;
		firstRect.fill = Paint.RGBColor( 1, 0, 0 );
		Root.appendChild( firstRect );

		/* Most properties of svg shapes are so-called "Traits",
		   and all shapes accept a dynamic object in the constructor
		   to set those traits. */
		   
		var secondRect = new Rectangle({ 
					x: 120., 
					y: 10., 
					width: 100., 
					height:	100., 
					fill: Paint.RGBColor(0,1,0) 
				});
		Root.appendChild( secondRect );
		
		
		/* The members of the object passed to the constructor don't have to be
		   of the absolutely correct type, so we can pass in e.g. Ints instead of Floats,
		   and in the case of fill and stroke, also SVG color names (as Strings).
		   In fact, any string that can appear in the SVG attribute will be accepted
		   (at least as far as xinf SVG conformance goes), so we could also pass "#00f",
		   "rgb(0,0,255)", etc.. for fill. */

		var thirdRect = new Rectangle({ 
					x: 230, y: 10, width: 100, height: 100, 
					fill: "blue" 
				});
		Root.appendChild( thirdRect );

		/* Finally, we have to pass control to the xinf main loop.
		   Note that this might return immediately (on flash), 
		   or never (on xinfinity). In any case, you shouldn't do
		   anything after calling Root.main(). */
		
		Root.main();
		
	}
}
