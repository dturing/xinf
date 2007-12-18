/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.ony.base.Element;
import xinf.type.Paint;

interface PaintProvider { 
	function getPaint( target:Element ) :Paint;
}

