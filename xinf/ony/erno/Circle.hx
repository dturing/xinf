/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Circle extends xinf.ony.Circle  {

    override public function drawContents( g:Renderer ) :Void {
        if( r!=0 ) {
            super.drawContents(g);
            g.ellipse( cx, cy, r, r );
        }
    }
    
}
