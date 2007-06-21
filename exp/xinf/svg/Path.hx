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

package xinf.svg;

import xinf.erno.Renderer;

/**
    SVG Path element.
**/

class Path extends Element {
    var path:String;
    var started:Bool;
    var last:{x:Float,y:Float};
    
    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("d") ) path = xml.get("d");
        else path=null;
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( path!=null ) {
			// TODO: cache?
            drawPath( g, path );
        }
    }

    static var command = ~/[ \t\n\r]*([MLQCSZAlqcsza])/;
    static var float = ~/[ \t\n\r,]*([0-9\.\-]+)([e0-9\-])*[ \t\n\r,]*/;

    function parseFloats( text:String, n:Int ) :{ a:Array<Float>, rest:String } {
        var a = new Array<Float>();
        for( i in 0...n ) {
            if( float.match(text) ) {
                var m = float.matchedPos();
                a.push( Std.parseFloat(float.matched(1)) );
                // FIXME matched(2) might contain exponent!
                text = text.substr( m.pos+m.len );
            } else {
                throw("expected number, but got '"+text+"'");
            }
        }
        return { a:a, rest:text };
    }
    
    function parseMoveTo( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 2 );
        if( started ) g.endPath();
        g.startPath( r.a[0], r.a[1] );
        last = { x:r.a[0], y:r.a[1] };
        started=true;
        return r.rest;
    }

    function parseMoveToRel( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 2 );
        if( started ) g.endPath();
        last = { x:last.x+r.a[0], y:last.y+r.a[1] };
        g.startPath( last.x, last.y );
        started=true;
        return r.rest;
    }
    
    function parseLineTo( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 2 );
        g.lineTo( r.a[0], r.a[1] );
        last = { x:r.a[0], y:r.a[1] };
        return r.rest;
    }

    function parseLineToRel( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 2 );
        last = { x:last.x+r.a[0], y:last.y+r.a[1] };
        g.lineTo( last.x, last.y );
        return r.rest;
    }

    function parseQuadraticTo( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 4 );
        g.quadraticTo( r.a[0], r.a[1], r.a[2], r.a[3] );
        last = { x:r.a[2], y:r.a[3] };
        return r.rest;
    }

    function parseQuadraticToRel( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 4 );
        var c = { x:last.x+r.a[0], y:last.y+r.a[1] };
        var last = { x:last.x+r.a[2], y:last.y+r.a[3] };
        g.quadraticTo( c.x, c.y, last.x, last.y );
        return r.rest;
    }

    function parseCurveTo( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 6 );
        g.cubicTo( r.a[0], r.a[1], r.a[2], r.a[3], r.a[4], r.a[5] );
        last = { x:r.a[4], y:r.a[5] };
        return r.rest;
    }

    function parseCurveToRel( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 6 );
        var c1 = { x:last.x+r.a[0], y:last.y+r.a[1] };
        var c2 = { x:last.x+r.a[2], y:last.y+r.a[3] };
        var last = { x:last.x+r.a[4], y:last.y+r.a[5] };
        g.cubicTo( c1.x, c1.y, c2.x, c2.y, last.x, last.y );
        return r.rest;
    }

    function parseArcTo( g:Renderer, path:String ) :String {
        var r = parseFloats( path, 7 );
        arcTo( g, r.a[0], r.a[1], r.a[2], r.a[3]==1, r.a[4]==1, r.a[5], r.a[6] );
        return r.rest;
    }
    
    static var ELLIPSE_SEGMENTS:Int = 8;
    function ellipseSegment( g:Renderer, cx:Float, cy:Float, rx:Float, ry:Float, phi:Float, theta:Float, dTheta:Float ) {
        var a1 = theta + dTheta/2;
        var a2 = theta + dTheta;
        var f = Math.cos( dTheta/2 );
        
        var p1 = { x: Math.cos(a1)*rx / f, y: Math.sin(a1)*ry / f };
        var p2 = { x: Math.cos(a2)*rx, y: Math.sin(a2)*ry };
        p1 = rotatePoint(p1,phi);
        p2 = rotatePoint(p2,phi);
        
        g.quadraticTo( cx+p1.x, cy+p1.y, cx+p2.x, cy+p2.y );
    }
    
    function arcTo( g:Renderer, rx:Float, ry:Float, rotation:Float, largeArcFlag:Bool, sweepFlag:Bool, x:Float, y:Float ) {
  //  trace("arcTo "+rx+","+ry+", "+rotation+", "+largeArcFlag+", "+sweepFlag+", "+x+", "+y );
        var a = (rotation/180)*Math.PI;
        var A = last;
        var B = { x:x, y:y };
        var P = { x:(A.x-B.x)/2, y:(A.y-B.y)/2 };
        P = rotatePoint( P, -a );

        var lambda = (Math.pow(P.x,2)/Math.pow(rx,2)) + (Math.pow(P.y,2)/Math.pow(rx,2));
        if( lambda>1 ) {
            rx *= Math.sqrt(lambda);
            ry *= Math.sqrt(lambda);
        }
        
        var f = ( (Math.pow(rx,2)*Math.pow(ry,2))-(Math.pow(rx,2)*Math.pow(P.y,2))-Math.pow(ry,2)*Math.pow(P.x,2))
            / ( (Math.pow(rx,2)*Math.pow(P.y,2)) + (Math.pow(ry,2)*Math.pow(P.x,2)) );
        if( f<0 ) f=0 else f=Math.sqrt(f);
        if( largeArcFlag==sweepFlag ) f*=-1;
        
        var C_ =  { x: rx/ry*P.y, y: -ry/rx*P.x };
        C_.x*=f; C_.y*=f;
        var C = C_;
        
        C = rotatePoint(C,a);
        C = { x: C.x + ((A.x+B.x)/2),
              y: C.y + ((A.y+B.y)/2) };
        
        var theta = Math.atan2( (P.y-C_.y)/ry, (P.x-C_.x)/rx );
        var dTheta = Math.atan2( (-P.y-C_.y)/ry, (-P.x-C_.x)/rx)-theta;
        
        if( sweepFlag && dTheta<0 ) dTheta += 2*Math.PI;
        if( !sweepFlag && dTheta>0 ) dTheta -= 2*Math.PI;
        
        for( i in 0...ELLIPSE_SEGMENTS ) {
            ellipseSegment( g, C.x, C.y, rx, ry, a, dTheta/ELLIPSE_SEGMENTS*i + theta, dTheta/ELLIPSE_SEGMENTS );
        }
        last = B;
    }

    // rotate point around origin- move to some point class?
    function rotatePoint( p:{x:Float,y:Float}, phi:Float ) :{x:Float,y:Float} {
        return { x: (Math.cos(phi)*p.x) + (-Math.sin(phi)*p.y),
                 y: (Math.sin(phi)*p.x) + (Math.cos(phi)*p.y) };
    }

    function drawPath( g:Renderer, path:String ) :Void {
        // FIXME: parse the string every time? whee!
        
        g.startShape();
        started = false;
        last = {x:0.,y:0.};
        //trace("PATH: "+path );
        while( command.match(path) ) {
            var cmd = command.matched(1);
            var m = command.matchedPos();
            path = path.substr( m.pos+m.len );
            switch( cmd ) {
                case "M":
                    path = parseMoveTo( g, path );
                case "L":
                    path = parseLineTo( g, path );
                case "C":
                    path = parseCurveTo( g, path );
                case "Q":
                    path = parseQuadraticTo( g, path );
                case "A":
                    path = parseArcTo( g, path );
                case "m":
                    path = parseMoveToRel( g, path );
                case "l":
                    path = parseLineToRel( g, path );
                case "q":
                    path = parseQuadraticTo( g, path );
                case "c":
                    path = parseCurveToRel( g, path );
                case "Z":
                    if( started ) g.endPath();
                    started=false;
                case "z":
                    if( started ) g.endPath();
                    started=false;
                default:
                    trace("unknown shape command "+command.matched(1));
            }
        }
        // FIXME: should check if there's anything left (but whitespace)
//        if( path.length>0 ) throw("cannot parse path '"+path+"'");
        
        if( started ) g.endPath();
        g.endShape();
    }
}
