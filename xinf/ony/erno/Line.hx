package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;

class Line extends xinf.ony.base.Line  {

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        g.startShape();
            g.startPath( x1, y1 );
            g.lineTo( x2, y2 );
            g.endPath();
        g.endShape();
    }
    
}
