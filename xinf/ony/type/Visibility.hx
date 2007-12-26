/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	Defines wether something should be visible or not.
	
	Contrary to $xinf.ony.type.Display$, Visibility only
	applies to the one element in question, not it's children
	(although it is inherited). That means, e.g., 
	if a $xinf.ony.Group$ has visibility [Hidden], 
	any children that specify visibility [Visible] 
	will still be shown.

	The "collapse" value is currently not supported.

	$SVG painting#VisibilityProperty the "visibility" property$
*/
enum Visibility {
    Visible;
    Hidden;
}
