/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.geom.Types;

class Polygon extends xinf.ony.Polygon  {

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
            
            // close if not closed.
            if( p.x != p0.x || p.y != p0.y ) {
                g.lineTo( p0.x, p0.y );
            }
            
            g.endPath();
            
        g.endShape();
    }
    
}
