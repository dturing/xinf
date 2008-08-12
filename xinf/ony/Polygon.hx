/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.ony.traits.PointListTrait;

class Polygon extends ElementImpl {

	static var TRAITS = {
		points:	new PointListTrait(),
	};
	
	static var tagName = "polygon";

	public var points(get_points,set_points):Iterable<TPoint>;
	function get_points() :Iterable<TPoint> {
		return getTrait("points",Dynamic); // FIXME: messy, as in polyline
	}
	function set_points( v:Iterable<TPoint> ) {
		setTrait("points",v); redraw(); return v;
	}

	// FIXME: double code with Polyline
	override public function getBoundingBox() : TRectangle {
		var pi = points.iterator();
		if( !pi.hasNext() ) {
			return { l:0., t:0., r:0., b:0. };
		}
		var p = pi.next();
		var xmin=p.x, xmax=p.x, ymin=p.y, ymax=p.y;
		while( pi.hasNext() ) {
			p = pi.next();
			if( p.x<xmin ) xmin=p.x;
			if( p.x>xmax ) xmax=p.x;
			if( p.y<ymin ) ymin=p.y;
			if( p.y>ymax ) ymax=p.y;
		}
		return { l:xmin, t:ymin, r:xmax, b:ymax };
	}

}
