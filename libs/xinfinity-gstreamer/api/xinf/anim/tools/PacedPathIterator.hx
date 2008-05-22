/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

import xinf.geom.Types;

class PacedPathIterator implements FlatPathIterator {
	var path:FlatPath;
	var step:Float;
	var l:Float;
	var p:Int;
	var totalLength:Float;
	
	public function new( path:FlatPath, step:Float ) {
		l = 0.;
		p = 0;
		this.path=path;
		this.step=step;
		totalLength=path.length();
	}
	
	public function reset() :Void {
		l = 0.;
		p = 0;
	}
	
	public function jumpTo( t:Float ) :Void {
		p=0;
		l = t*totalLength;
	}
	
	public function hasNext() :Bool {
		return l<totalLength;
	}
	
	public function next() :TPoint {
		while( l>path.alengths[p] ) p++;
		var ll = if( p>0 ) (l-path.alengths[p-1]) else l;
		var i = ll / path.lengths[p];
		var seg = path.segments[p];
		var p1 = seg.a;
		var p2 = seg.b;
		l+=step;
		return({ 
			x: p1.x + ( (p2.x-p1.x)*i ),
			y: p1.y + ( (p2.y-p1.y)*i )
		});
	}
	
	static var PI15 = Math.PI*1.5;
	function rot( seg:LineSegment ) :Float {
		var r = Math.atan2( seg.a.x-seg.b.x, seg.a.y-seg.b.y );
		return( PI15-r );
	}
	public function rotation() :Float {
		if( p==0 ) return rot( path.segments[0] );
		if( p>=path.segments.length-1 ) return rot( path.segments[path.segments.length-1] );
		var a:LineSegment;
		var b:LineSegment;
		var i = (l-path.alengths[p-1])/path.lengths[p];
		if( i<.5 ) {
			a = path.segments[p-1];
			b = path.segments[p];
			i+=.5;
		} else if( i>.5 ) {
			a = path.segments[p];
			b = path.segments[p+1];
			i-=.5;
		} else {
			return rot( path.segments[p] );
		}
		var r1=rot(a); var r2=rot(b);
		while( (r2-r1)>Math.PI ) r2-=Math.PI;
		while( (r2-r1)<-Math.PI ) r2+=Math.PI;
		return( r1 + (i*(r2-r1)) );
	}
	
	public function finalPoint() :TPoint {
		return path.segments[path.segments.length-1].b;
	}

	public function finalRotation() :Float {
		return rot( path.segments[path.segments.length-1] );
	}

}
