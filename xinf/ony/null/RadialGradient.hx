/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.null;

class RadialGradient extends xinf.ony.RadialGradient, implements PaintServer {

	public function getPaint( target:xinf.ony.Element ) :xinf.erno.Paint {
		return xinf.erno.Paint.None;
	}
		
}
