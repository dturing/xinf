/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Crop extends xinf.ony.Crop  {

    override public function drawContents( g:Renderer ) :Void {
		g.clipRect( width, height );
        super.drawContents(g);
    }
    
}
