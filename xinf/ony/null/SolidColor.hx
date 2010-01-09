/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.null;

class SolidColor extends xinf.ony.SolidColor, implements PaintServer {

	public function getPaint( target:xinf.ony.Element ) :xinf.erno.Paint {
		return xinf.erno.Paint.None;
	}

}


