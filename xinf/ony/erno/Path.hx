/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;

import xinf.ony.PathSegment;


class Path extends Object, implements xinf.ony.Path  {

    public var segments(default,set_segments):Iterable<PathSegment>;

    private function set_segments(v:Iterable<PathSegment>) {
        segments=v; scheduleRedraw(); return segments;
    }

    public function new() :Void {
        super();
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("d") ) {
            segments = new PathParser().parse(xml.get("d"));
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        
        g.startShape();
        var open=false;
        var last = { x:0., y:0. };
        var first = { x:0., y:0. };
        
        /*
            REC-SVG-1.1 8.3.6:
                If there is no previous command or if the previous command 
                was not an C, c, S or s, assume the first control point is 
                coincident with the current point.
            and .7
                ... was not a Q, q, T or t, ...
                
            being very strict on this, we keep two "smooth points" and reset 
            them if no commands sets the corresponding ?smooth2.
        */
        var csmooth = null;
        var qsmooth = null;
        
        for( seg in segments ) {
            var csmooth2 = null;
            var qsmooth2 = null;
            
            switch( seg ) {

                case MoveTo(x,y):
                    if( open ) g.endPath();
                    g.startPath(x,y);
                    open=true;
                    last = { x:x, y:y };
                    first = { x:x, y:y };

                case MoveToR(x,y):
                    if( open ) g.endPath();
                    first = { x:last.x+x, y:last.y+y };
                    last = { x:last.x+x, y:last.y+y };
                    g.startPath(last.x,last.y);
                    open=true;

                case Close:
                    if( open ) {
                        // FIXME depends on various things...
                        g.lineTo( first.x, first.y );
                        g.endPath();
                        last=first;
                    }
                    open=false;
                    
                case LineTo(x,y):
                    g.lineTo(x,y);
                    last = { x:x, y:y };

                case LineToR(x,y):
                    last = { x:last.x+x, y:last.y+y };
                    g.lineTo(last.x,last.y);

                case HorizontalTo(x):
                    g.lineTo(x,last.y);
                    last.x=x;

                case HorizontalToR(x):
                    last = { x:last.x+x, y:last.y };
                    g.lineTo(last.x,last.y);

                case VerticalTo(y):
                    g.lineTo(last.x,y);
                    last.y=y;

                case VerticalToR(y):
                    last = { x:last.x, y:last.y+y };
                    g.lineTo(last.x,last.y);

                case CubicTo(x1,y1,x2,y2,x,y):
                    g.cubicTo(x1,y1,x2,y2,x,y);
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case CubicToR(x1,y1,x2,y2,x,y):
                    g.cubicTo(last.x+x1,last.y+y1,last.x+x2,last.y+y2,last.x+x,last.y+y);
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothCubicTo(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    g.cubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), x2, y2, x, y );
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case SmoothCubicToR(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    g.cubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), last.x+x2, last.y+y2, last.x+x, last.y+y );
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };
                    
                case QuadraticTo(x1,y1,x,y):
                    g.quadraticTo(x1,y1,x,y);
                    last = { x:x, y:y };
                    qsmooth2 = { x:x1, y:y1 };

                case QuadraticToR(x1,y1,x,y):
                    g.quadraticTo(last.x+x1,last.y+y1,last.x+x,last.y+y);
                    qsmooth2 = { x:last.x+x1, y:last.y+y1 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothQuadraticTo(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    g.quadraticTo( s.x, s.y, x, y );
                    last = { x:x, y:y };
                    qsmooth2 = { x:s.x, y:s.y };

                case SmoothQuadraticToR(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    g.quadraticTo( s.x, s.y, last.x+x, last.y+y );
                    last = { x:last.x+x, y:last.y+y };
                    qsmooth2 = s;

                case ArcTo(rx,ry,rotation,largeArc,sweep,x,y):
                    g.arcTo(rx,ry,rotation,largeArc,sweep,x,y);
                    last = { x:x, y:y };
                    
                default:
                    throw("unimplemented path segment "+seg );
            }
            csmooth=csmooth2; csmooth2=null;
            qsmooth=qsmooth2; qsmooth2=null;
        }
        
        if( open ) g.endPath();
        
        g.endShape();
    }

}
