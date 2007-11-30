package xinf.ony.base;

import xinf.geom.Transform;
import xinf.geom.Translate;
import xinf.geom.Matrix;
import xinf.erno.Paint;
import xinf.geom.Types;

import xinf.ony.base.Gradient;

class LinearGradient extends Gradient {
	
    public var x1(get_x1,set_x1):Null<Float>;
    public var y1(get_y1,set_y1):Null<Float>;
    public var x2(get_x2,set_x2):Null<Float>;
    public var y2(get_y2,set_y2):Null<Float>;

	function set_x1(v:Null<Float>) :Null<Float> { return x1=v; }
	function set_y1(v:Null<Float>) :Null<Float> { return y1=v; }
	function set_x2(v:Null<Float>) :Null<Float> { return x2=v; }
	function set_y2(v:Null<Float>) :Null<Float> { return y2=v; }
	function get_x1() :Null<Float> {
		if( x1!=null ) return x1;
//		if( peer!=null ) return peer.x1;
		return 0.;
	}
	function get_y1() :Null<Float> {
		if( y1!=null ) return y1;
//		if( peer!=null ) return peer.y1;
		return 0.;
	}
	function get_x2() :Null<Float> {
		if( x2!=null ) return x2;
//		if( peer!=null ) return peer.x2;
		return 1.;
	}
	function get_y2() :Null<Float> {
		if( y2!=null ) return y2;
//		if( peer!=null ) return peer.y2;
		return 0.;
	}

	override public function getPaint( target:Element ) :Paint {	
		var p1 = {x:x1,y:y1};
		var p2 = {x:x2,y:y2};

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
			p1 = m.apply(p1);
			p2 = m.apply(p2);
		}

		return PLinearGradient(stops,p1.x,p1.y,p2.x,p2.y,spreadMethod);
	}
	
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);

		if( xml.exists("x1") )
			x1 = getFloatProperty(xml,"x1");
		if( xml.exists("y1") )
			y1 = getFloatProperty(xml,"y1");
		if( xml.exists("x2") )
			x2 = getFloatProperty(xml,"x2");
		if( xml.exists("y2") )
			y2 = getFloatProperty(xml,"y2");

	}
}
