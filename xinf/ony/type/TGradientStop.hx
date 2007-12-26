/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	Defines a color stop for a Gradient.
	
	[color] defines the Color to be used at the stop.
	
	[offset] defines the offset of the stop, 0 to 1.
	
	See $xinf.type.Paint$.
	
	$SVG painting#StopElement The "stop" element in SVG$
*/
typedef TGradientStop = {
	color :Color,
	offset :Float
}
