package org.xinf.display;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;

class Graphics {
    public function new() {
    }

    public function _render( r:IRenderer ) {
    
        r.translate( -.25, -.25 );
        r.setColor( 1.0, 1.0, 1.0, 0.5 );
        r.polygon( [
                new Point(.5,0),
                new Point(.5,.5),
                new Point(0,.5),
                new Point(0,0)
            ]);
    }
}
