/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.ony.type.PathSegment;

class Path extends xinf.ony.Path  {

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( segments==null ) return;
        
        g.startShape();

		var open=false;
		for( s in segments ) {
			switch(s) {
				case MoveTo(x,y):
					if( open ) g.endPath();
					open=true;
					g.startPath(x,y);
				case LineTo(x,y):
					open=true;
					g.lineTo(x,y);
				case Close:
					g.close();
					g.endPath();
					open=false;
				case QuadraticTo(x1,y1,x,y):
					open=true;
					g.quadraticTo(x1,y1,x,y);
				case CubicTo(x1,y1,x2,y2,x,y):
					open=true;
					g.cubicTo(x1,y1,x2,y2,x,y);
				case ArcTo(x1,y1,rx,ry,rotation,largeArc,sweep,x,y):
					open=true;
					g.arcTo(x1,y1,rx,ry,rotation,largeArc,sweep,x,y);
			}
		}
		if( open ) g.endPath();

        g.endShape();
    }

}
