/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.flash9;

import xinf.erno.ImageData;

class ImageDataRegion extends ImageData {

	public function new ( original:ImageData, region:{ x:Float, y:Float, w:Float, h:Float } ) {
		super();
		
		bitmapData = new flash.display.BitmapData( Math.round( region.w ), Math.round( region.h ) );
		bitmapData.copyPixels( original.bitmapData, new flash.geom.Rectangle( Math.round( region.x ), Math.round( region.y ), Math.round( region.w ), Math.round( region.h ) ), new flash.geom.Point( 0, 0 ) );
	}
    
}