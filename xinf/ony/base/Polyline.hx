package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;

class Polyline extends ElementImpl  {

    public var points(default,set_points):Iterable<TPoint>;
    private function set_points(v:Iterable<TPoint>) {
        points=v; redraw(); return points;
    }

    public function new() :Void {
        super();
        points = null;
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
