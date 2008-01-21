/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.geom.Transform;

/**
	A Paint specifies the Color or Gradient (in the
	future, also Pattern or PaintServer) to use for filling
	or stroking a shape.

	$SVG painting#SpecifyingPaint Specifying paint in SVG$
*/
enum Paint {
	/** do not stroke/fill the shape in question at all
	*/
	None;
	
	/** use the solid RGBA color described.
	*/
	SolidColor( r:Float, g:Float, b:Float, a:Float );
	
	/** fill or stroke using the linear gradient described.
	
		[x1,y1,x2] and [y2] describe the gradient
		vector in user space units.
	
		$SVG painting#LinearGradientElement Linear gradients in SVG$
	*/
	PLinearGradient( stops:Iterable<TGradientStop>, x1:Float, y1:Float, x2:Float, y2:Float, transform:Transform, spread:Int );
	
	/** fill or stroke using the radial gradient described.

		[cx,cy,r,fx] and [fy] are in user space units.
		
		([cx,cy,r]) describe the center and radius of the
		largest (outermost) circle for the radial gradient.
		
		([fx,fy]) describe the focal point for the radial gradient.

		$SVG painting#RadialGradientElement Radial gradients in SVG$
	*/
	PRadialGradient( stops:Iterable<TGradientStop>, cx:Float, cy:Float, r:Float, fx:Float, fy:Float, transform:Transform, spread:Int );
	
//	Pattern( ... );
}
