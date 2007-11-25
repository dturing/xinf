package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;

class Ellipse extends xinf.ony.base.Ellipse  {

    override public function drawContents( g:Renderer ) :Void {
        if( rx!=0 && ry!=0 ) {
            super.drawContents(g);
            g.ellipse( cx, cy, rx, ry );
        }
    }
    
}
