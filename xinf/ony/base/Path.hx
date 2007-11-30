package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.ony.PathSegment;
import xinf.ony.PathParser;
import xinf.geom.Types;

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

class Path extends ElementImpl {

    public var segments(default,set_segments):Iterable<PathSegment>;

    private function set_segments(v:Iterable<PathSegment>) {
        segments=v; redraw(); return segments;
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

}
