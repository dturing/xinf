/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.geom.Types;

class Polyline extends xinf.ony.Polyline  {

    override public function drawContents( g:Renderer ) :Void {
        if( points==null ) return;
        var ps = points.iterator();
        if( !ps.hasNext() ) return;
            
        super.drawContents(g);
        g.startShape();
        
            var p0 = ps.next();
            g.startPath( p0.x, p0.y );
            
            var p:TPoint;
            while( ps.hasNext() ) {
                p = ps.next();
                g.lineTo( p.x, p.y );
            }
            
            g.endPath();
            
        g.endShape();
    }
    
}
