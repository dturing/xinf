/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.ony.type.PathSegment;
import xinf.ony.PathParser;
import xinf.geom.Types;

private class PathBBox {
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
		for( s in segments ) {
			switch( s ) {
				case MoveTo(x,y): 
					proc(x,y);
				case LineTo(x,y):
					proc(x,y);
					
		/* FIXME curve and arc bboxes are not precise **/
                case CubicTo(x1,y1,x2,y2,x,y):
					proc(x1,y1); proc(x2,y2); proc(x,y);

                case QuadraticTo(x1,y1,x,y):
					proc(x1,y1); proc(x,y);
					
                case ArcTo(x1,y1,rx,ry,rotation,largeArc,sweep,x,y):
					proc(x,y);
                    
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

	static var tagName = "path";

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
            segments = PathParser.simplify(
				new PathParser().parse(xml.get("d")
				));
        }
    }
	
}
