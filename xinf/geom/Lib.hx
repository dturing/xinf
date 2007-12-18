/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;
import xinf.geom.Vector;

class Lib {

	/**
		Create arrays of control and anchor points that define a Cubic Bezier. This is the
		fixed midpoint implementation.<br />
		p0: Start point<br />
		p1: Control point 1<br />
		p2: Control point 2<br />
		p3: End point
	**/
	public static function cubicBezierFM(p0: TPoint, p1: TPoint, p2: TPoint, p3: TPoint) :
		{ control:Array<TPoint>, anchor:Array<TPoint> }
	{
		// Adapted from work by Timoth�e Groleau
		// http://timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm
		var v1 = new Vector(p0,p1);
		var v2 = new Vector(p3,p2);
		var v3 = new Vector(v1.getRatioPoint(0.75), v2.getRatioPoint(0.75));
		var v4 = v3.reverse();

		// get 1/16 of the [p3, p0] segment
		var dx = (p3.x - p0.x)/16;
		var dy = (p3.y - p0.y)/16;

		// control point 1
		var cp1 = v1.getRatioPoint(0.375);

		// control point 2
		var cp2 = v3.getRatioPoint(0.375);
		cp2.x -= dx;
		cp2.y -= dy;

		// control point 3
		var cp3 = v4.getRatioPoint(0.375);
		cp3.x += dx;
		cp3.y += dy;

		// control point 4
		var cp4 = v2.getRatioPoint(0.375);

		// 3 anchor points
		var ap1 = new Vector(cp1, cp2).middle;
		var ap2 = v3.middle;
		var ap3 = new Vector(cp3, cp4).middle;

		return {
			control: [cp1, cp2, cp3, cp4],
			anchor: [ap1, ap2, ap3, p3]
		}
	}

	public static function degreesToRadians(v:Float) : Float {
		return v / 180 * Math.PI;
	}

	public static function radiansToDegrees(v:Float) : Float {
		return v * 180 / Math.PI;
	}

	public static function rotatePoint(p:TPoint, radAngle:Float) : TPoint {
			return {
				x: (Math.cos(radAngle)*p.x) + (-Math.sin(radAngle)*p.y),
				y: (Math.sin(radAngle)*p.x) + (Math.cos(radAngle)*p.y)
			};
	}
    public static function rotatePoints( p:Array<TPoint>, radAngle:Float ) : Array<TPoint> {
		var newPoints = new Array<TPoint>();
		for(i in 0...p.length) {
        	newPoints[i] = rotatePoint(p[i], radAngle);
		}
		return newPoints;
    }

	public static function translatePoint(p:TPoint, tx:Float, ty:Float):TPoint {
		if(Math.isNaN(tx))
			tx = 0.;
		if(Math.isNaN(ty))
			ty = 0.;
		return {
			x: p.x + tx,
			y: p.y + ty
		};
	}
	public static function translatePoints(p:Array<TPoint>, tx:Float, ty:Float):Array<TPoint>
	{
		var newPoints = new Array<TPoint>();
		for(i in 0...p.length) {
        	newPoints[i] = translatePoint(p[i], tx, ty);
		}
		return newPoints;
    }

	/*
		These are part of the arcTo using cubic beziers.
		Already slower by 15% than current implementation,
		but it certainly will be closer to rendering properly.
		It is currently not complete.

	public static function ellipseToCubicBezier(box:Rectangle) : Array<Array<TPoint>> {
		var k = 0.2761423749154; //  2/3 * (sqrt(2)-1)
		var offx = box.w() * k;
		var offy = box.h() * k;
		var pc = box.center();
		var p : Array<Array<TPoint>> = new Array();
		for(i in 0...4) {
			p[i] = new Array<TPoint>();
			for(j in 0...4) {
				p[i][j] = {x:0.,y:0.};
			}
		}
		//4 sets of 4 points, starting top, clockwise a,c,c,a,c,c,a...
		p[0][0].x = p[3][3].x = p[1][3].x = p[2][0].x = pc.x;
		p[0][2].x = p[0][3].x = p[1][0].x = p[1][1].x = box.r;
		p[3][0].x = p[3][1].x = p[2][2].x =  p[2][3].x  = box.l;
		p[2][1].x = p[3][2].x = pc.x - offx;
		p[0][1].x = p[1][2].x = pc.x + offx;

		p[3][0].y = p[2][3].y = p[0][3].y = p[1][0].y = pc.y;
		p[3][2].y = p[3][3].y = p[0][0].y = p[0][1].y = box.t;
		p[1][2].y = p[1][3].y = p[2][0].y = p[2][1].y = box.b;
		p[1][1].y = p[2][2].y = pc.y + offy;
		p[3][1].y = p[0][2].y = pc.y - offy;

		return p;
	}

	public static function arcToCubicBezier(startPoint:TPoint,rx:Float,ry:Float,radRotation:Float,sweepFlag:Bool,largeArcFlag:Bool,?endPoint:TPoint) : Array<Array<TPoint>>
	{

		var quad : Int = -1; // -1 draw all
		var rect : xinf.geom.Rectangle;
		var tx : Float = startPoint.x;
		var ty : Float = startPoint.y;

// trace("From " + Std.string(startPoint) + " to " + Std.string(endPoint));
// trace("rx: "+ rx + " ry: "+ ry);
// trace(sweepFlag);
// trace(largeArcFlag);

		if(sweepFlag != largeArcFlag) {
			tx = startPoint.x;
			ty = startPoint.y + if(startPoint.y < 0) -ry else ry;
		}
		else {
			tx = startPoint.x + if(startPoint.x < 0) -rx else rx;
			ty = startPoint.y;
		}
		rect = new xinf.geom.Rectangle();
		rect.setPoints({x:-rx,y:-ry}, {x:rx,y:ry});

		var cbp = ellipseToCubicBezier(rect);

		// rotate
		if(radRotation != 0.) {
			for(i in 0...cbp.length) {
				cbp[i] = rotatePoints(cbp[i],radRotation);
			}
		}

		if(endPoint != null) {
			//var pc = rect.center();
			var ep = rotatePoint({x:endPoint.x - tx, y:endPoint.y - ty}, -radRotation);

			// quadrant, 0-3 clockwise from topright
			if(ep.x >= 0) { // quad 0 or 1
				if(ep.y > 0)
					quad = 1;
				else
					quad = 0;
			}
			else { // quad 2 or 3
				if(ep.y > 0)
					quad = 2;
				else
					quad = 3;
			}
		}

//trace(cbp[3]);

		var draw = new Array<Array<TPoint>>();
		var reverse = function(a : Array<TPoint>) : Array<TPoint> {
			var n = a.slice(0);
			n.reverse();
			return n;
		}
//trace("Quadrant: " + quad);
		if(sweepFlag == largeArcFlag) {
			if(largeArcFlag) { // works 1,1
				draw.push(cbp[3]);
//trace(cbp[3]);
				if(quad != 3) {
//trace(cbp[0]);
					draw.push(cbp[0]);
					if(quad != 0) {
						draw.push(cbp[1]);
//trace(cbp[1]);
						if(quad != 1) {
							draw.push(cbp[2]);
//trace(cbp[2]);
						}
					}
				}
			}
			else { // doesn't 0,0
				draw.push(reverse(cbp[2]));
//trace(cbp[2]);
//trace(draw[0]);
				if(quad != 2) {
					draw.push(reverse(cbp[1]));
					if(quad != 1) {
						draw.push(reverse(cbp[0]));
						if(quad != 0) {
							draw.push(reverse(cbp[3]));
						}
					}
				}
			}
		}
		else {
			if(largeArcFlag) {  // doesn't 1,0
				draw.push(reverse(cbp[3]));
				if(quad != 3) {
					draw.push(reverse(cbp[2]));
					if(quad != 2) {
						draw.push(reverse(cbp[1]));
						if(quad != 1) {
							draw.push(reverse(cbp[0]));
						}
					}
				}
			}
			else { // works 0,1
				draw.push(cbp[0]);
				if(quad != 0) {
					draw.push(cbp[1]);
					if(quad != 1) {
						draw.push(cbp[2]);
						if(quad != 2) {
							draw.push(cbp[3]);
						}
					}
				}
			}
		}

		// reset the end point.
		draw[draw.length-1][3].x = endPoint.x - tx;
		draw[draw.length-1][3].y = endPoint.y - ty;

		// last arc must be recalculated
		//var a = angle of endpoint
		//var ca1 = angle of cp1;
		//var ca2 = angle of cp2;
/*
		{
			var lR : Float; // large radius
			var sR : Float; // small radius
			var x = draw[draw.length-1].x;
			var y = draw[draw.length-1].y;
			if(rx > ry) {
				lR = rx;
				sR = ry;
			}
			else {
				lR = ry;
				sR = rx;
			}
			//var lR = Math.max(rx, ry);
			//var sR = Math.min(rx, ry);
			var p = new xinf.geom.Point(x, lR * y / b);
			var ny = a * y / b;
			var t = Math.atan(ny/x);

		}
*/
/*
//		trace(radiansToDegrees(Math.atan(1)));

		// rotate/translate

		if(tx != 0. || ty != 0.) {
//			trace("Translating");
			for(i in 0...draw.length) {
				draw[i] = translatePoints(draw[i],tx,ty);
			}
		}

		// [anchor, control, control, anchor], [anchor, control...
		return draw;
	}
*/
}

