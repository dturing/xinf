/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	Possible values for 
	$xinf.ony.type.PreserveAspectRatio$.Preserve(x,y).
*/
enum Align {
	/** align the graphic's left edge to the viewport's
		left edge (or respectively top to top) */
	Min;
	
	/** align the graphic's center to the viewport's
		center */
	Mid;

	/** align the graphic's right edge to the viewport's
		right edge (or respectively bottom to bottom) */
	Max;
}


/**
	The PreserveAspectRatio enum describes the method
	used to uniformly stretch some graphic element.
	
	For example, SVG's "defer xMinYMax meet" is expressed
	as [Defer( Meet( Preserve( Min, Max ) )].
	
	$xinf.ony.traits.PreserveAspectRatioTrait::align$ can be used
	to apply the method to a given viewBox/viewport combination.

	$SVG coords#PreserveAspectRatioAttribute The 'preserveAspectRatio' attribute$
*/
enum PreserveAspectRatio {
	/**
		Defers preservance of aspect ratio to the referenced
		element, or uses [o] if the referenced element does
		not express a method.
		
		This is not factually implemented.
	*/
	Defer( o:PreserveAspectRatio );
	
	/**
		Not quite sure what the "meet" argument implies.
		The SVG specification calls it "optional and only
		available due to historical reasons", so it 
		can probably be ignored.
		
		Current implementation just ignores it, and
		applies [o].
	*/
	Meet( o:PreserveAspectRatio );

	/**
		Do not preserve aspect ratio, scale the
		graphic non-uniformly to fit the viewport.
	*/
	None;
	
	/**
		Preserve aspect ratio with the given
		alignment on X- resp. Y-Axis.
	*/
	Preserve( x:Align, y:Align );
}
