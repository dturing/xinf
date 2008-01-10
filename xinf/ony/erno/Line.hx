/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Line extends xinf.ony.Line  {

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        g.startShape();
            g.startPath( x1, y1 );
            g.lineTo( x2, y2 );
            g.endPath();
        g.endShape();
    }
    
}
