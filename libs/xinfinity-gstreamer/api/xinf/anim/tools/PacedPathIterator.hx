/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

class PacedPathIterator {
	var path:FlatPath;
	var step:Float;
	var l:Float;
	var p:Int;
	var totalLength:Float;
	
	public function new( path:FlatPath, step:Float, ?start:Float ) {
		l = if( start==null ) 0. else start; 
		p = 0;
		this.path=path;
		this.step=step;
		totalLength=path.length();
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
}
