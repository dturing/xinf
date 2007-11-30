package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;

class Circle extends xinf.ony.base.Circle  {

    override public function drawContents( g:Renderer ) :Void {
        if( r!=0 ) {
            super.drawContents(g);
            g.ellipse( cx, cy, r, r );
        }
    }
    
}
