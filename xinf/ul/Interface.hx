/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.geom.Types;
import xinf.event.GeometryEvent;

class Interface extends Container {
	var area:TRectangle;

	public function new( g:Group ) {
		super( g );

		var a = g.getTypedElementByName( "area", xinf.ony.Rectangle );
		area = { l:a.x, t:a.y, r:a.x+a.width, b:a.y+a.height };
		setPrefSize( { x:area.r-area.l, y:area.b-area.t } );
	}
}
