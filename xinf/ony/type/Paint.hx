/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	A Paint specifies the Color, or reference to a PaintServer
	to use for filling or stroking a shape.

	$SVG painting#SpecifyingPaint Specifying paint in SVG$
*/
enum Paint {
	/** do not stroke/fill the shape in question at all
	*/
	None;
	
	/** use the PaintServer specified by [url]. 
		Currently, only references by id to Gradients
		in the current Document are supported 
	*/
	URLReference( url:String );
	
	/** use the solid RGB color described.
	*/
	RGBColor( r:Float, g:Float, b:Float );

}
