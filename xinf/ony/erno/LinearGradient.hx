/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.geom.Transform;
import xinf.geom.Translate;
import xinf.geom.Concatenate;
import xinf.geom.Scale;
import xinf.geom.Matrix;
import xinf.geom.Types;

import xinf.ony.type.GradientUnits;
import xinf.erno.Paint;
import xinf.erno.Constants;

class LinearGradient extends xinf.ony.LinearGradient, implements PaintServer {

	public function getPaint( target:xinf.ony.Element ) :xinf.erno.Paint {	
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
		
		var spread:Int = switch( spreadMethod ) {
			case PadSpread: Constants.SPREAD_PAD;
			case ReflectSpread: Constants.SPREAD_REFLECT;
			case RepeatSpread: Constants.SPREAD_REPEAT;
		}

		return PLinearGradient(stops,p1.x,p1.y,p2.x,p2.y,transform,spread);
	}
	
}
