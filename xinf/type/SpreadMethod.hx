/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.type;

/**
	Describes the spread method to use for gradients.
	See $xinf.type.Paint$.
	
	SVG does not specify spread methods.
	FIXME: so document it here!
*/
enum SpreadMethod {
	PadSpread;
	ReflectSpread;
	RepeatSpread;
}
