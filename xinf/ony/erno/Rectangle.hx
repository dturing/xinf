/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Rectangle extends xinf.ony.Rectangle  {
	
    override public function drawContents( g:Renderer ) :Void {
		if( width<=0 || height<=0 ) return;
        super.drawContents(g);
        if( rx==0 && ry==0 ) {
            g.rect( x, y, width, height );
        } else {
            var ry2=ry;
            if( ry2==0. ) ry2=rx;
            var rx2=rx;
            if( rx2==0. ) rx2=ry2;
            if( rx2 > (width/2) ) rx2 = width/2;
            if( ry2 > (height/2) ) ry2 = height/2;
            g.roundedRect( x, y, width, height, rx2, ry2 );
        }
    }
    
}
