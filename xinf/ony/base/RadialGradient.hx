package xinf.ony.base;

import xinf.geom.Transform;
import xinf.geom.Translate;
import xinf.geom.Matrix;
import xinf.erno.Paint;
import xinf.geom.Types;

import xinf.ony.base.Gradient;

class RadialGradient extends Gradient {
	
    public var cx(get_cx,set_cx):Null<Float>;
    public var cy(get_cy,set_cy):Null<Float>;
    public var r(get_r,set_r):Null<Float>;
    public var fx(get_fx,set_fx):Null<Float>;
    public var fy(get_fy,set_fy):Null<Float>;

	function set_cx(v:Null<Float>) :Null<Float> { return cx=v; }
	function set_cy(v:Null<Float>) :Null<Float> { return cy=v; }
	function set_r(v:Null<Float>) :Null<Float> { return r=v; }
	function set_fx(v:Null<Float>) :Null<Float> { return fx=v; }
	function set_fy(v:Null<Float>) :Null<Float> { return fy=v; }
	function get_cx() :Null<Float> {
		if( cx!=null ) return cx;
//		if( peer!=null ) return peer.x1;
		return .5;
	}
	function get_cy() :Null<Float> {
		if( cy!=null ) return cy;
//		if( peer!=null ) return peer.y1;
		return .5;
	}
	function get_r() :Null<Float> {
		if( r!=null ) return r;
//		if( peer!=null ) return peer.y1;
		return .5;
	}
	function get_fx() :Null<Float> {
		if( fx!=null ) return fx;
//		if( peer!=null ) return peer.fx;
		if( cx!=null ) return cx;
		return .5;
	}
	function get_fy() :Null<Float> {
		if( fy!=null ) return fy;
//		if( peer!=null ) return peer.y2;
		if( cy!=null ) return cy;
		return .5;
	}

	override public function getPaint( target:Element ) :Paint {	
		var center = {x:cx,y:cy};
		var focus = {x:fx,y:fy};
		var pr = {x:r,y:0.}
		var _r = r;

		var transform:Transform = null;
		
		if( gradientTransform != null ) {
			transform = gradientTransform;
		}

		if( gradientUnits == ObjectBoundingBox ) {
			var bbox = target.getBoundingBox();
			var t = new Concatenate(
							new Scale( bbox.r-bbox.l, bbox.b-bbox.t ),
							new Translate( bbox.l, bbox.t ) ).getMatrix();
			if( transform!=null ) transform = new Concatenate( transform, t );
			else transform = t;
		}

		if( transform!=null ) {
			var m = new Matrix(transform.getMatrix());
			center = m.apply(center);
			focus = m.apply(focus);
			pr = m.apply(pr);
			_r = Math.sqrt( (pr.x*pr.x)+(pr.y*pr.y) );
		}

		return PRadialGradient(stops,center.x,center.y,_r,focus.x,focus.y,spreadMethod);
	}
	
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);

		if( xml.exists("cx") )
			cx = getFloatProperty(xml,"cx");
		if( xml.exists("cy") )
			cy = getFloatProperty(xml,"cy");
		if( xml.exists("r") )
			r = getFloatProperty(xml,"r");
		if( xml.exists("fx") )
			fx = getFloatProperty(xml,"fx");
		if( xml.exists("fy") )
			fy = getFloatProperty(xml,"fy");

	}
}
