/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.geom.Types;

class Polyline extends Object, implements xinf.ony.Polygon  {

    public var points(default,set_points):Iterable<TPoint>;
    private function set_points(v:Iterable<TPoint>) {
        points=v; scheduleRedraw(); return points;
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

    override public function drawContents( g:Renderer ) :Void {
        if( points==null ) return;
        var ps = points.iterator();
        if( !ps.hasNext() ) return;
            
        super.drawContents(g);
        g.startShape();
        
            var p0 = ps.next();
            g.startPath( p0.x, p0.y );
            
            var p:TPoint;
            while( ps.hasNext() ) {
                p = ps.next();
                g.lineTo( p.x, p.y );
            }
            
            g.endPath();
            
        g.endShape();
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
