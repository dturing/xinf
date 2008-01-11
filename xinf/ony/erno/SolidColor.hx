/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.ony.type.Paint;
import xinf.traits.SpecialTraitValue;

class SolidColor extends xinf.ony.SolidColor, implements PaintServer {

	public function getPaint( target:xinf.ony.Element ) :xinf.erno.Paint {
		var c:Paint;
		var o = solidOpacity;
		
		var v = Reflect.field( _traits, "solid-color" );
		if( v == CurrentColor.currentColor ) {
			c = target.color;
		} else {
			c = getTrait("solid-color",Paint);
		}
		
		switch( c ) {
			case RGBColor(r,g,b):
				return xinf.erno.Paint.SolidColor( r, g, b, o );
			default:
		}
		return xinf.erno.Paint.None;
	}

}


