package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;

import xinf.ony.PathSegment;

class Path extends xinf.ony.base.Path  {

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( segments==null ) return;
        
        g.startShape();

		xinf.ony.base.Path.simplify( segments, untyped g );

        g.endShape();
    }

}
