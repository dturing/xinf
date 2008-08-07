/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Circle extends xinf.ony.Circle  {

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
	}
	
	override public function drawContents( g:Renderer ) :Void {
		if( r!=0 ) {
			super.drawContents(g);
			g.ellipse( cx, cy, r, r );
		}
	}
	
}
