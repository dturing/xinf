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
			/* compare SVG-T 1.2 11.16.1:
				When gradientUnits="objectBoundingBox" the stripes 
				of the linear gradient shall be perpendicular to the 
				gradient vector in object bounding box space (i.e., 
				the abstract coordinate system where (0,0) is at the 
				top/left of the object bounding box and (1,0) is at 
				the top/right of the object bounding box). When the 
				object's bounding box is not square, the stripes that 
				are conceptually perpendicular to the gradient vector 
				within object bounding box space shall render non-
				perpendicular relative to the gradient vector in user 
				space due to application of the non-uniform scaling 
				transformation from bounding box space to user space.

				this doesnt really fix it, only for one sample case, and messes up the normal cases:
			var p = { x:bbox.r-bbox.l, y:bbox.b-bbox.t };
			var f=2*(p.y/p.x);
//							new Scale( f*p.y, f*p.x ),
			*/
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
		
		var spread:Int = switch( spreadMethod ) {
			case PadSpread: Constants.SPREAD_PAD;
			case ReflectSpread: Constants.SPREAD_REFLECT;
			case RepeatSpread: Constants.SPREAD_REPEAT;
		}

		return PLinearGradient(stops,p1.x,p1.y,p2.x,p2.y,spread);
	}
	
}
