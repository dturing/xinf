/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.geom.Transform;
import xinf.geom.Translate;
import xinf.geom.Matrix;
import xinf.geom.Types;
import xinf.ony.type.GradientUnits;
import xinf.erno.Paint;
import xinf.erno.Constants;

class RadialGradient extends xinf.ony.RadialGradient, implements PaintServer {
	
	public function getPaint( target:xinf.ony.Element ) :xinf.erno.Paint {	
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

		var spread:Int = switch( spreadMethod ) {
			case PadSpread: Constants.SPREAD_PAD;
			case ReflectSpread: Constants.SPREAD_REFLECT;
			case RepeatSpread: Constants.SPREAD_REPEAT;
		}

		return PRadialGradient(stops,center.x,center.y,_r,focus.x,focus.y,spread);
	}
	
}
