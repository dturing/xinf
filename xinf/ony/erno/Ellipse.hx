/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Ellipse extends xinf.ony.Ellipse  {

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
	}

	override public function drawContents( g:Renderer ) :Void {
		if( rx!=0 && ry!=0 ) {
			super.drawContents(g);
			g.ellipse( cx, cy, rx, ry );
		}
	}
	
}
