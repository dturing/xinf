/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.ony.type.PathSegment;
import xinf.ony.traits.PathTrait;
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

	static var TRAITS = {
		d: new PathTrait(),
	};
	
	static var tagName = "path";

	public var segments(get_segments,set_segments):Iterable<PathSegment>;
	function get_segments() :Iterable<PathSegment> {
		return getTrait("d",Dynamic);
	}
	function set_segments( v:Iterable<PathSegment> ) {
		setTrait("d",v); redraw(); return v;
	}

	public var d(get_d,set_d):String;
	function get_d() :String {
		return getTrait("d",String);
	}
	function set_d( v:String ) {
		setTraitFromString("d",v,_traits); redraw(); return v;
	}

	override public function getBoundingBox() : TRectangle {
		return new PathBBox(segments);
	}

}
