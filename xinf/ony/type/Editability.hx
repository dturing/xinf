/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	Defines wether something (usually something text-related)
	should be editable or not.
	
	Currently only supported on $xinf.ony.TextArea$, not
	on $xinf.ony.Text$ (and there also maybe with
	a grain of salt).
	
	$SVG text#editable-attribute The "editable" attribute$
*/
enum Editability {
    None;
    Simple;
}
