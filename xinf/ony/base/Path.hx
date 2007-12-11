package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.ony.PathSegment;
import xinf.ony.PathParser;
import xinf.geom.Types;

// TODO: replace with simplified!
class PathBBox {
	public var l:Float;
	public var t:Float;
	public var r:Float;
	public var b:Float;
	
	public function new( ?segments:Iterable<PathSegment> ) {
		if( segments!=null ) calculate(segments);
	}
	
	public function calculate( segments:Iterable<PathSegment> ) :PathBBox {
		l=t=Math.POSITIVE_INFINITY;
		r=b=Math.NEGATIVE_INFINITY;
        var csmooth:TPoint = null;
        var qsmooth:TPoint = null;
		var csmooth2:TPoint = null;
		var qsmooth2:TPoint = null;
		var last = { x:0., y:0. };
		for( s in segments ) {
			switch( s ) {
				case MoveTo(x,y): 
					proc(x,y);
					last={x:x,y:y};
				case MoveToR(x,y):
					proc(last.x+x,last.y+y);
					last={x:last.x+x,y:last.y+y};
				case LineTo(x,y):
					proc(x,y);
					last={x:x,y:y};
				case LineToR(x,y):
					proc(last.x+x,last.y+y);
					last={x:last.x+x,y:last.y+y};
				case HorizontalTo(x):
					proc(x,last.y);
					last={x:x,y:last.y};
				case HorizontalToR(x):
					proc(last.x+x,last.y);
					last={x:last.x+x,y:last.y};
				case VerticalTo(y):
					proc(last.x,y);
					last={x:last.x,y:y};
				case VerticalToR(y):
					proc(last.x,last.y+y);
					last={x:last.x,y:last.y+y};
					
		/* FIXME curve and arc bboxes are not precise **/
                case CubicTo(x1,y1,x2,y2,x,y):
					proc(x1,y1); proc(x2,y2); proc(x,y);
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case CubicToR(x1,y1,x2,y2,x,y):
					proc(last.x+x1,last.y+y1); proc(last.x+x2,last.y+y2); proc(last.x+x,last.y+y);
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothCubicTo(x2,y2,x,y):
					proc( last.x+(last.x-csmooth.x), last.y+(last.y-csmooth.y) );
					proc(x2,y2);
					proc(x,y);
                    if( csmooth==null ) csmooth=last;
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case SmoothCubicToR(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    proc( last.x+(last.x-csmooth.x), last.y+(last.y-csmooth.y) );
					proc( last.x+x2, last.y+y2 );
					proc( last.x+x, last.y+y );
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };
                    
                case QuadraticTo(x1,y1,x,y):
					proc(x1,y1); proc(x,y);
                    last = { x:x, y:y };
                    qsmooth2 = { x:x1, y:y1 };

                case QuadraticToR(x1,y1,x,y):
                    proc(last.x+x1,last.y+y1); proc(last.x+x,last.y+y);
                    qsmooth2 = { x:last.x+x1, y:last.y+y1 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothQuadraticTo(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    proc( s.x, s.y );
					proc( x, y );
                    last = { x:x, y:y };
                    qsmooth2 = { x:s.x, y:s.y };

                case SmoothQuadraticToR(x,y):
                    if( qsmooth==null ) qsmooth=last;
					var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
					proc( s.x, s.y );
					proc( last.x+x, last.y+y );
                    last = { x:last.x+x, y:last.y+y };
                    qsmooth2 = s;

                case ArcTo(rx,ry,rotation,largeArc,sweep,x,y):
					proc(x,y);
                    last = { x:x, y:y };
					
				default:
			}
		}
		return this;
	}
	
	function proc( x:Float, y:Float ) {
		if( x<l ) l=x;
		if( x>r ) r=x;
		if( y<t ) t=y;
		if( y>b ) b=y;
	}
}


typedef SimplifiedPathRenderer = {
	var startPath:Float->Float->Void;
	var endPath:Void->Void;
	var lineTo:Float->Float->Void;
	var quadraticTo:Float->Float->Float->Float->Void;
	var cubicTo:Float->Float->Float->Float->Float->Float->Void;
	var arcTo:Float->Float->Float->Bool->Bool->Float->Float->Void;
	/* means:
	public function startPath( x:Float, y:Float ) :Void;
	public function endPath() :Void;
    public function lineTo( x:Float, y:Float ) :Void;
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) :Void;
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) :Void;
    public function arcTo( rx:Float, ry:Float, rotation:Float, largeArc:Bool, sweep:Bool, x:Float, y:Float ) :Void;
	*/
}

class Path extends ElementImpl {

    public var segments(default,set_segments):Iterable<PathSegment>;

    private function set_segments(v:Iterable<PathSegment>) {
        segments=v; redraw(); return segments;
    }

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		if( segments!=null ) to.segments = Lambda.array(segments);
	}

	override public function getBoundingBox() : TRectangle {
		return new PathBBox(segments);
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("d") ) {
            segments = new PathParser().parse(xml.get("d"));
        }
    }


	public static function simplify( segments:Iterable<PathSegment>, g:SimplifiedPathRenderer ) {
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

        var open=false;
        var last = { x:0., y:0. };
        var first = { x:0., y:0. };
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
	}
}
