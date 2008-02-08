/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

class FlatPath {
	public var segments:Array<LineSegment>;
	public var lengths:Array<Float>;
	public var alengths:Array<Float>;
	var lastL:Float;
	
	public function new() {
		segments = new Array<LineSegment>();
		lengths = new Array<Float>();
		alengths = new Array<Float>();
		lastL = 0.;
	}
	
	public function push( seg:LineSegment ) :Void {
		segments.push( seg );
		var l = seg.length();
		lastL += l;
		lengths.push( l );
		alengths.push( lastL );
	}

	public function addSpline( p0:TPoint, p1:TPoint, p2:TPoint, p3:TPoint, ?n:Int ) :Void {
		var spline = new Spline( p0, p1, p2, p3 );
		var last = p0;
		if( n==null ) n=50;
		for( i in 0...n ) {
			var next = spline.at( (i+1)/n );
			push( new LineSegment( last, next ) );
			last = next;
		}
	}

	public function flatten( segments:Iterable<PathSegment> ) :Void {
		var last:TPoint = { x:0., y:0. };
		var first:TPoint;
		
		for( segment in segments ) {
			switch( segment ) {
				case MoveTo(x,y):
					first = last = { x:x, y:y };
				case Close:
					push( new LineSegment( last, first ) );
				case LineTo(x,y):
					var next = { x:x, y:y };
					push( new LineSegment( last, next ) );
					last = next;
				case QuadraticTo( x1, y1, x, y ):
					var p1 = { x: last.x + (((x1-last.x)*2)/3),
							   y: last.y + (((y1-last.y)*2)/3) };
					var p2 = { x: p1.x + ((x-last.x)/3),
							   y: p1.y + ((y-last.y)/3) };
					addSpline( last, p1, p2, {x:x,y:y} );
					last = { x:x, y:y };
				case CubicTo( x1, y1, x2, y2, x, y ):
					addSpline( last, {x:x1,y:y1}, {x:x2,y:y2}, {x:x,y:y} );
					last = { x:x, y:y };
				case ArcTo( x1, x2, rx, ry, rotation, largeArc, sweep, x, y ):
					// TODO
					trace("WARNING: Arc segments flattening not yet implemented");
					var next = { x:x, y:y };
					push( new LineSegment( last, next ) );
					last = next;
			}
		}
	}

	public function length() :Float {
		return( lastL );
	}
}
