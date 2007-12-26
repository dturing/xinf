/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	Defines wether something should be displayed or not.
	
	Not all possible values of the SVG "display" property are
	supported, but only None and Inline make sense for Xinf
	(currently, at least).

	$SVG painting#DisplayProperty the "display" property$
*/
enum Display {
	/** do not display the element in question, or any of it's children */
	None;
	
	/** display the element in question normally */
	Inline;
}
