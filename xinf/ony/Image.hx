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

package xinf.ony;

import xinf.erno.Renderer;
import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;

/**
    An Image. You have to create an <a href="../erno/ImageData.html">ImageData</a> object
    to pass into the constructor. The Image will be redrawn as soon as the ImageData
    is completely loaded. The complete image is displayed in the rectangle defined by
    [Object.size]. If the size is not set, it will default to the original image size.
    (you can draw parts of an image if you override the drawContents method).
**/
class Image extends Object {
    
    private var img:ImageData;

    public function new( i:ImageData ) :Void {
        super();
        img = i;
        if( img.width!=null ) {
            size.x = img.width;
            size.y = img.height;
        }
        img.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        img.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        img.addEventListener( ImageLoadEvent.LOADED, dataChanged );
    }
    
    private function dataChanged( e:ImageLoadEvent ) :Void {
        if( size.x==0 && size.y==0 ) {
            size.x = img.width;
            size.y = img.height;
        }
        scheduleRedraw();
    }
    
    public function drawContents( g:Renderer ) :Void {
        if( img==null ) return;
        g.image( img, {x:0,y:0,w:img.width,h:img.height}, {x:0,y:0,w:size.x,h:size.y} );
     }
    
}
