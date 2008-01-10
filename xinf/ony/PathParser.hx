/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.ony.type.SVGPathSegment;

private typedef SimpleSegment = xinf.ony.type.PathSegment;

private enum PathParserState {
    Empty;
    ParseCommand( cmd:String, nargs:Int );
    ParseFloat( s:String, old:PathParserState );
}

class PathParser {
    static var commandReg = ~/[MmZzLlHhVvCcSsQqTtAa]/;

    var g:Array<SVGPathSegment>;

    var input:String;
    var pin:Int;

    var state:PathParserState;
    var args:Array<Float>;
    
    public function new() {
        state=Empty;
    }

    public function parse( pathToParse:String ) :Iterable<SVGPathSegment> {
        input=pathToParse;
        pin=0;
        args = new Array<Float>();
        g = new Array<SVGPathSegment>();
        
        while( pin<input.length ) {
            var c = input.charAt(pin);
           // trace("CHAR '"+c+"', STATE "+state);
            if( StringTools.isSpace(c,0) || c=="," ) {  // whitespace
                endState();
			} else if( c=="-" ) {            // - (minus) // fixme should trigger new float, except when in exponent like "1.324e-12"
                switch( state ) {
                    case ParseFloat(f,old):
                        if( f.length==0 ) state=ParseFloat("-",old);
						else if( f.charAt(f.length-1)=="e" ) {
							state=ParseFloat(f+c,old);
							pin++;
                        } else {
                            endState();
                            state=ParseFloat("-",state);
                        }
                    default:
                        state=ParseFloat("-",state);
                        pin++;
                }
			} else if( commandReg.match(c) ) {
                endState();
                parseCommand(commandReg.matched(0));
            } else {
                switch( state ) {
                    case ParseFloat(f,old):
                        state = ParseFloat(f+c,old);
                        pin++;
                    default:
                        state = ParseFloat(c,state);
                        pin++;
                }
            }
        }
        endState();
        
        return g;
    }
    
    function parseCommand( cmd:String ) {
        var nargs = switch(cmd.toUpperCase()) {
            case "Z":
                0;
            case "H","V":
                1;
            case "M","L","T":
                2;
            case "S","Q":
                4;
            case "C":
                6;
            case "A":
                7;
        }    
        state = ParseCommand(cmd,nargs);
    }
    
    function fail() {
        throw("failed parsing path '"+input.substr(pin)+"'");
    }
    
    function endState() {
       //trace("END "+state );
        switch( state ) {
        
            case Empty:
                pin++;
                
            case ParseFloat(c,old):
                args.push( Std.parseFloat(c) );
                state = old;
                endState();
                
            case ParseCommand(cmd,nargs):
                if( args.length==nargs ) {
        //            trace("COMMAND "+cmd+", args: "+args );
                    command( cmd, args );
                    args = new Array<Float>();
                    if( nargs==0 ) state=Empty;
                    else if( cmd.toUpperCase()=="M" ) {
                        if( cmd=="M" ) cmd="L";
                        else cmd="l";
                        parseCommand(cmd);
                    }
                } 
                pin++;
                
        }
    }
    
    function command( cmd:String, a:Array<Float> ) {
        var op = 
            switch( cmd ) {
                case "M":
                    MoveTo( a[0], a[1] );
                case "m":
                    MoveToR( a[0], a[1] );
                case "L":
                    LineTo( a[0], a[1] );
                case "l":
                    LineToR( a[0], a[1] );
                case "H":
                    HorizontalTo( a[0] );
                case "h":
                    HorizontalToR( a[0] );
                case "V":
                    VerticalTo( a[0] );
                case "v":
                    VerticalToR( a[0] );
                case "C":
                    CubicTo( a[0], a[1], a[2], a[3], a[4], a[5] );
                case "c":
                    CubicToR( a[0], a[1], a[2], a[3], a[4], a[5] );
                case "S":
                    SmoothCubicTo( a[0], a[1], a[2], a[3] );
                case "s":
                    SmoothCubicToR( a[0], a[1], a[2], a[3] );
                case "Q":
                    QuadraticTo( a[0], a[1], a[2], a[3] );
                case "q":
                    QuadraticToR( a[0], a[1], a[2], a[3] );
                case "T":
                    SmoothQuadraticTo( a[0], a[1] );
                case "t":
                    SmoothQuadraticToR( a[0], a[1] );
                case "A":
                    ArcTo( a[0], a[1], a[2], a[3]==0., a[4]==0., a[5], a[6] );
                case "a":
                    ArcToR( a[0], a[1], a[2], a[3]==0., a[4]==0., a[5], a[6] );
                case "Z":
                    Close;
                case "z":
                    Close;
                default:
                    throw("unimplemented shape command "+cmd);
            }
        
        g.push(op);
    }
	
	public static function simplify( segments:Iterable<SVGPathSegment> ) :Array<SimpleSegment> {
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
		
		var out = new Array<SimpleSegment>();
        var last = { x:0., y:0. };
		var first = { x:0., y:0. };
        var csmooth = null;
        var qsmooth = null;
        
        for( seg in segments ) {
            var csmooth2 = null;
            var qsmooth2 = null;
            
            switch( seg ) {

                case MoveTo(x,y):
                    out.push( SimpleSegment.MoveTo(x,y) );
                    last = { x:x, y:y };
                    first = { x:x, y:y };

                case MoveToR(x,y):
                    first = { x:last.x+x, y:last.y+y };
                    last = { x:last.x+x, y:last.y+y };
                    out.push( SimpleSegment.MoveTo( last.x,last.y ));

                case Close:
					out.push( SimpleSegment.Close );
					last = first;
                    
                case LineTo(x,y):
                    out.push( SimpleSegment.LineTo( x, y ));
                    last = { x:x, y:y };

                case LineToR(x,y):
                    last = { x:last.x+x, y:last.y+y };
                    out.push( SimpleSegment.LineTo( last.x, last.y ));

                case HorizontalTo(x):
                    out.push( SimpleSegment.LineTo( x, last.y ));
                    last.x=x;

                case HorizontalToR(x):
                    last = { x:last.x+x, y:last.y };
                    out.push( SimpleSegment.LineTo( last.x, last.y ));

                case VerticalTo(y):
                    out.push( SimpleSegment.LineTo( last.x, y ));
                    last.y=y;

                case VerticalToR(y):
                    last = { x:last.x, y:last.y+y };
                    out.push( SimpleSegment.LineTo( last.x, last.y ));

                case CubicTo(x1,y1,x2,y2,x,y):
                    out.push( SimpleSegment.CubicTo(x1,y1,x2,y2,x,y) );
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case CubicToR(x1,y1,x2,y2,x,y):
                    out.push( SimpleSegment.CubicTo(last.x+x1,last.y+y1,last.x+x2,last.y+y2,last.x+x,last.y+y) );
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothCubicTo(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    out.push( SimpleSegment.CubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), x2, y2, x, y ));
                    last = { x:x, y:y };
                    csmooth2 = { x:x2, y:y2 };

                case SmoothCubicToR(x2,y2,x,y):
                    if( csmooth==null ) csmooth=last;
                    out.push( SimpleSegment.CubicTo( last.x + (last.x-csmooth.x), last.y + (last.y-csmooth.y), last.x+x2, last.y+y2, last.x+x, last.y+y ));
                    csmooth2 = { x:last.x+x2, y:last.y+y2 };
                    last = { x:last.x+x, y:last.y+y };
                    
                case QuadraticTo(x1,y1,x,y):
                    out.push( SimpleSegment.QuadraticTo(x1,y1,x,y) );
                    last = { x:x, y:y };
                    qsmooth2 = { x:x1, y:y1 };

                case QuadraticToR(x1,y1,x,y):
                    out.push( SimpleSegment.QuadraticTo(last.x+x1,last.y+y1,last.x+x,last.y+y) );
                    qsmooth2 = { x:last.x+x1, y:last.y+y1 };
                    last = { x:last.x+x, y:last.y+y };

                case SmoothQuadraticTo(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    out.push( SimpleSegment.QuadraticTo( s.x, s.y, x, y ) );
                    last = { x:x, y:y };
                    qsmooth2 = { x:s.x, y:s.y };

                case SmoothQuadraticToR(x,y):
                    if( qsmooth==null ) qsmooth=last;
                    var s = { x:last.x + (last.x-qsmooth.x), y:last.y + (last.y-qsmooth.y) };
                    out.push( SimpleSegment.QuadraticTo( s.x, s.y, last.x+x, last.y+y ) );
                    last = { x:last.x+x, y:last.y+y };
                    qsmooth2 = s;

                case ArcTo(rx,ry,rotation,largeArc,sweep,x,y):
                    out.push( SimpleSegment.ArcTo(last.x,last.y,rx,ry,rotation,largeArc,sweep,x,y) );
                    last = { x:x, y:y };

                case ArcToR(rx,ry,rotation,largeArc,sweep,x,y):
                    out.push( SimpleSegment.ArcTo(last.x,last.y,rx,ry,rotation,largeArc,sweep,last.x+x,last.y+y) );
                    last = { x:last.x+x, y:last.y+y };

                default:
                    throw("unimplemented path segment "+seg );
            }
            csmooth=csmooth2; csmooth2=null;
            qsmooth=qsmooth2; qsmooth2=null;
        }
		
		return out;
	}
	
}
