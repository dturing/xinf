/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

/**
	Defines a color stop for a Gradient.
	
	[r], [g], [b] and [a] define the RGBA color to be used at the stop,
	with values from 0.0 to 1.0.
	
	[offset] defines the offset of the stop, 0 to 1.
	
	See $xinf.type.Paint$.
	
	$SVG painting#StopElement The "stop" element in SVG$
*/
typedef TGradientStop = {
	r :Float,
	g :Float,
	b :Float,
	a :Float,
	offset :Float
}
