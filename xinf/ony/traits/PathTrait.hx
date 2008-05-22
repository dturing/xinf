/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.PathSegment;
import xinf.ony.PathParser;

class PathTrait extends TypedTrait<Iterable<PathSegment>> {

	public function new() {
		super( new List<PathSegment>() );
	}

	override public function parse( value:String ) :Dynamic {
		var d = PathParser.simplify(
				new PathParser().parse(value));
		return d;
	}

	override public function write( value:Dynamic ) :String {
		var r = "";
		var v:Iterable<PathSegment> = cast(value);
		for( s in v ) {
			switch( s ) {
				case MoveTo(x,y):
					r+="M"+x+" "+y+" ";
				case Close:
					r+="Z ";
				case LineTo(x,y):
					r+="L"+x+" "+y+" ";
				case QuadraticTo(x1,y1,x,y):
					r+="Q"+x1+" "+y1+" "+x+" "+y+" ";
				case CubicTo(x1,y1,x2,y2,x,y):
					r+="C"+x1+" "+y1+" "+x2+" "+y2+" "+x+" "+y+" ";
				case ArcTo(x1,y1,rx,ry,rotation,largeArc,sweep,x,y):
					r+"A"+x1+" "+y1+" "+rx+" "+ry+" "+rotation+" "+(largeArc?"1":"0")+" "+(sweep?"1":"0")+" "+x+" "+y+" ";
			}
		}
		return r;
	}

	override public function getDefault() :Dynamic {
		return new List<PathSegment>();
	}

}
