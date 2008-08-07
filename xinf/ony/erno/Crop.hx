/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Crop extends xinf.ony.Crop  {

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
	}

	override public function drawContents( g:Renderer ) :Void {
		g.clipRect( width, height );
		super.drawContents(g);
	}
	
}
