/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.flash9;

import xinf.erno.ImageData;

class ImageDataRegion extends ImageData {

	public function new ( original:ImageData, region:{ x:Float, y:Float, w:Float, h:Float } ) {
		super();
		
		bitmapData = new flash.display.BitmapData( Math.round( region.w ), Math.round( region.h ) );
		bitmapData.copyPixels( original.bitmapData, new flash.geom.Rectangle( Math.round( region.x ), Math.round( region.y ), Math.round( region.w ), Math.round( region.h ) ), new flash.geom.Point( 0, 0 ) );
	}
    
}