/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.PreserveAspectRatio;
import xinf.geom.Types;

typedef TRect = {
	x:Float,
	y:Float,
	w:Float,
	h:Float
}

class PreserveAspectRatioTrait extends TypedTrait<PreserveAspectRatio> {

	var def:PreserveAspectRatio;
	
	public function new( ?def:PreserveAspectRatio ) {
		super( PreserveAspectRatio );
		if( def==null ) def = PreserveAspectRatio.None;
		this.def=def;
	}

	override public function getDefault() :Dynamic {
		return def;
	}

    static var ws = ~/[ \r\n\t]+/g;
	static var par = ~/x(M[indax]+)Y(M[indax]+)/;
	override public function parse( value:String ) :Dynamic {
		if( value=="none" ) return PreserveAspectRatio.None;
		
		var s = ws.split(value);
		var meet = false;
		var defer = false;
		
		var p = value;
		if( s.length>1 ) {
			if( s[0] == "defer" ) {
				defer = true;
				p = s[1];
			}
			if( s[s.length-1] == "meet" ) {
				meet = true;
				p = s[s.length-2];
			}
		}
		
		if( par.match(p) ) {
			var v = Preserve(
				parsePart(par.matched(1)),
				parsePart(par.matched(2)) );
			if( meet ) v = Meet( v );
			if( defer ) v = Defer( v );
			return v;
		} else {
			throw("invalid PreserveAspectRatio value: '"+p+"'");
		}
		return null;
    }
	
	function parsePart( s ) :Align {
		switch( s ) {
			case "Min":
				return Align.Min;
			case "Mid":
				return Align.Mid;
			case "Max":
				return Align.Max;
			default:
				throw("invalid PreserveAspectRatio value: '"+s+"'");
		}
	}
	
	public static function align( p:PreserveAspectRatio, viewBox:TPoint, viewPort:TPoint ) :TRect {
		switch( p ) {
			case None:
				return { x:0., y:0., w:viewPort.x, h:viewPort.y };
			case Defer(q):
				trace("Cannot defer preserveAspectRatio.");
				return align( q, viewBox, viewPort );
			case Meet(q):
				trace("Not sure what to do with preserveAspectRatio.Meet.");
				return align( q, viewBox, viewPort );
			case Preserve(x,y):
				return alignPreserve( viewBox, viewPort, x, y );
		}
	}
	
	static function alignPreserve( viewBox:TPoint, viewPort:TPoint, x:Align, y:Align ) :TRect {
		var scaleX = viewPort.x/viewBox.x;
		var scaleY = viewPort.y/viewBox.y;
		var aspect = viewPort.x/viewPort.y;
		var out;
				
		if( scaleX>scaleY ) {
			out = { x:0., y:0., w:viewBox.x*scaleY, h:viewBox.y*scaleY };
			switch( x ) {
				case Min:
					// nothing
				case Mid:
					out.x = (viewPort.x-out.w)/2;
				case Max:
					out.x = (viewPort.x-out.w);
			}
		} else {
			out = { x:0., y:0., w:viewBox.x*scaleX, h:viewBox.y*scaleX };
			switch( y ) {
				case Min:
					// nothing
				case Mid:
					out.y = (viewPort.y-out.h)/2;
				case Max:
					out.y = (viewPort.y-out.h);
			}
		}
		return out;
	}
}
