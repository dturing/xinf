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

import xinf.ony.PathSegment;


class Path extends Object, implements xinf.ony.Path  {

    public var segments(default,set_segments):Iterable<PathSegment>;

    private function set_segments(v:Iterable<PathSegment>) {
        segments=v; scheduleRedraw(); return segments;
    }

    public function new() :Void {
        super();
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("d") ) {
            segments = new PathParser().parse(xml.get("d"));
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        
        g.startShape();
        var open=false;
        var last = { x:0., y:0. };
        var first = { x:0., y:0. };
        
        /*
            REC-SVG-1.1 8.3.6:
                If there is no previous command or if the previous command 
                was not an C, c, S or s, assume the first control point is 
                coincident with the current point.
            and .7
                ... was not a Q, q, T or t, ...
                
            being very strict on this, we keep two "smooth points" and reset 
            them if no commands sets the corresponding ?smooth2.
        */
        var csmooth = null;
        var qsmooth = null;
        
        for( seg in segments ) {
            trace("draw "+seg );
            
            var csmooth2 = null;
            var qsmooth2 = null;
            
            switch( seg ) {

                case MoveTo(x,y):
                    if( open ) g.endPath();
                    g.startPath(x,y);
                    open=true;
                    last = { x:x, y:y };
                    first = { x:x, y:y };

                case MoveToR(x,y):
                    if( open ) g.endPath();
                    first = { x:last.x+x, y:last.y+y };
                    last = { x:last.x+x, y:last.y+y };
                    g.startPath(last.x,last.y);
                    open=true;

                case Close:
                    if( open ) {
                        // FIXME depends on various things...
                        g.lineTo( first.x, first.y );
                        g.endPath();
                        last=first;
                    }
                    open=false;
                    
                case LineTo(x,y):
                    g.lineTo(x,y);
                    last = { x:x, y:y };

                case LineToR(x,y):
                    last = { x:last.x+x, y:last.y+y };
                    g.lineTo(last.x,last.y);

                case HorizontalTo(x):
                    g.lineTo(x,last.y);
                    last.x=x;

                case HorizontalToR(x):
                    last = { x:last.x+x, y:last.y };
                    g.lineTo(last.x,last.y);

                case VerticalTo(y):
                    g.lineTo(last.x,y);
                    last.y=y;

                case VerticalToR(y):
                    last = { x:last.x, y:last.y+y };
                    g.lineTo(last.x,last.y);

                case CubicTo(x1,y1,x2,y2,x,y):
                    g.cubicTo(x1,y1,x2,y2,x,y);
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case CubicToR(x1,y1,x2,y2,x,y):
                    g.cubicTo(last.x+x1,last.y+y1,last.x+x2,last.y+y2,last.x+x,last.y+y);
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothCubicTo(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    g.cubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), x2, y2, x, y );
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case SmoothCubicToR(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    g.cubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), last.x+x2, last.y+y2, last.x+x, last.y+y );
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };
                    
                case QuadraticTo(x1,y1,x,y):
                    g.quadraticTo(x1,y1,x,y);
                    last = { x:x, y:y };
                    qsmooth2 = { x:x1, y:y1 };

                case QuadraticToR(x1,y1,x,y):
                    g.quadraticTo(last.x+x1,last.y+y1,last.x+x,last.y+y);
                    qsmooth2 = { x:last.x+x1, y:last.y+y1 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothQuadraticTo(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    g.quadraticTo( s.x, s.y, x, y );
                    last = { x:x, y:y };
                    qsmooth2 = { x:s.x, y:s.y };

                case SmoothQuadraticToR(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    g.quadraticTo( s.x, s.y, last.x+x, last.y+y );
                    last = { x:last.x+x, y:last.y+y };
                    qsmooth2 = s;

                case ArcTo(rx,ry,rotation,largeArc,sweep,x,y):
                    g.arcTo(rx,ry,rotation,largeArc,sweep,x,y);
                    last = { x:x, y:y };
                    
                default:
                    throw("unimplemented path segment "+seg );
            }
            csmooth=csmooth2; csmooth2=null;
            qsmooth=qsmooth2; qsmooth2=null;
        }
        
        if( open ) g.endPath();
        
        g.endShape();
    }

/*

    static var command1 = ~/[ \t\n\r]*([ZzHhVv])/;
    static var command2 = ~/[ \t\n\r]*([MmLlTt)/;
    static var command4 = ~/[ \t\n\r]*([SsQq])/;
    static var command6 = ~/[ \t\n\r]*([Cc])/;
    static var arcToCommand = ~/[ \t\n\r]*([Aa])/;
    static var float = ~/[ \t\n\r,]*(\-?[0-9\.]+)((e\-*)?[0-9])*; // a / is missing on the end! else, the /* comment is closed.

    function parsePath( path:String ) :Iterable<PathSegment> {
        var r = new Array<PathSegment>();

        while( path.length ) {
            if( command1.match(path) ) {
                path = parseCommand( command1.matched(1), 
            } else if( command2.match(path) ) {
            } else if( command4.match(path) ) {
            } else if( command6.match(path) ) {
            } else if( arcToCommand.match(path) ) {
            } else {
            }
            path=StringTools.trim(path);
        }
    }
    
    
    
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
     
    function parseMoveTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( MoveTo( r.a[0], r.a[1] ) );
        return r.rest;
    }

    function parseMoveToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( MoveToR( r.a[0], r.a[1] ) );
        return r.rest;
    }
    
    function parseLineTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( LineTo( r.a[0], r.a[1] ) );
        return r.rest;
    }

    function parseLineToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( LineToR( r.a[0], r.a[1] ) );
        return r.rest;
    }

    function parseHorizontalTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 1 );
        list.push( HorizontalTo( r.a[0] ) );
        return r.rest;
    }

    function parseHorizontalToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 1 );
        list.push( HorizontalToR( r.a[0] ) );
        return r.rest;
    }
    
    function parseVerticalTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 1 );
        list.push( VerticalTo( r.a[0] ) );
        return r.rest;
    }

    function parseVerticalToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 1 );
        list.push( VerticalToR( r.a[0] ) );
        return r.rest;
    }
    
    function parseCubicTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 6 );
        list.push( CubicTo( r.a[0], r.a[1], r.a[2], r.a[3], r.a[4], r.a[5] ) );
        return r.rest;
    }

    function parseCubicToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 6 );
        list.push( CubicToR( r.a[0], r.a[1], r.a[2], r.a[3], r.a[4], r.a[5] ) );
        return r.rest;
    }

    function parseSmoothCubicTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 4 );
        list.push( SmoothCubicTo( r.a[0], r.a[1], r.a[2], r.a[3] ) );
        return r.rest;
    }

    function parseSmoothCubicToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 4 );
        list.push( SmoothCubicToR( r.a[0], r.a[1], r.a[2], r.a[3] ) );
        return r.rest;
    }

    function parseQuadraticTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 4 );
        list.push( QuadraticTo( r.a[0], r.a[1], r.a[2], r.a[3] ) );
        return r.rest;
    }

    function parseQuadraticToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 4 );
        list.push( QuadraticToR( r.a[0], r.a[1], r.a[2], r.a[3] ) );
        return r.rest;
    }

    function parseSmoothQuadraticTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( SmoothQuadraticTo( r.a[0], r.a[1] ) );
        return r.rest;
    }

    function parseSmoothQuadraticToRel( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 2 );
        list.push( SmoothQuadraticToR( r.a[0], r.a[1] ) );
        return r.rest;
    }
    
    function parseArcTo( list:Array<PathSegment>, path:String ) :String {
        var r = parseFloats( path, 7 );
        list.push( ArcTo( r.a[0], r.a[1], r.a[2], r.a[3]==1, r.a[4]==1, r.a[5], r.a[6] ) );
        return r.rest;
    }

    function parseCommand( cmd:String, r:Array<PathSegment>, path:String ) :String {
        switch( cmd ) {
            case "M":
                path = parseMoveTo( r, path );
            case "m":
                path = parseMoveToRel( r, path );
            case "L":
                path = parseLineTo( r, path );
            case "l":
                path = parseLineToRel( r, path );
            case "H":
                path = parseHorizontalTo( r, path );
            case "h":
                path = parseHorizontalToRel( r, path );
            case "V":
                path = parseVerticalTo( r, path );
            case "v":
                path = parseVerticalToRel( r, path );
            case "C":
                path = parseCubicTo( r, path );
            case "c":
                path = parseCubicToRel( r, path );
            case "S":
                path = parseSmoothCubicTo( r, path );
            case "s":
                path = parseSmoothCubicToRel( r, path );
            case "Q":
                path = parseQuadraticTo( r, path );
            case "q":
                path = parseQuadraticToRel( r, path );
            case "T":
                path = parseSmoothQuadraticTo( r, path );
            case "t":
                path = parseSmoothQuadraticToRel( r, path );
            case "A":
                path = parseArcTo( r, path );
            case "Z":
                r.push( Close );
            case "z":
                r.push( Close );
            default:
                throw("unimplemented shape command "+command.matched(1));
        }
        return path;
    }

    function parsePath( path:String ) :Iterable<PathSegment> {
        var r = new Array<PathSegment>();
        var cmd = "L";
        
        while( command.match(path) ) {
            var m = command.matchedPos();
            if( m.pos>0 ) {
                var rest = path.substr(0,m.pos);
                while( rest.length>0 ) {
                    var nrest = parseCommand( cmd, r, rest );
                    if( nrest.length==rest.length ) throw("cannot parse intermediate '"+rest+"'");
                    rest = nrest;
                }
            }
            
            var cmd = command.matched(1);
            path = path.substr( m.pos+m.len );
            trace("parse segment "+cmd+", rest "+path );
            
            path = parseCommand( cmd, r, path );
        }
        if( path.length>0 && StringTools.trim(path).length>0 ) throw("unhandled rest-of-path: '"+path+"'" );

        return r;
    }
*/
}
