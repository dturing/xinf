package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;

class Polygon extends ElementImpl {

    public var points(default,set_points):Iterable<TPoint>;
    private function set_points(v:Iterable<TPoint>) {
        points=v; redraw(); return points;
    }

    public function new() :Void {
        super();
        points = null;
    }

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

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("points") ) 
            points = parsePoints( xml.get("points") );
    }

    static var pointSplit = ~/[ ,]+/g;
    function parsePoints( str:String ) :Iterable<TPoint> {
        var ps = new Array<TPoint>();
        var s = pointSplit.split( str );
        
        while( s.length>1 ) {
            var x = Std.parseFloat( s.shift() );
            var y = Std.parseFloat( s.shift() );
            ps.push( {x:x, y:y} );
            
        }
        
        return ps;
    }

}
