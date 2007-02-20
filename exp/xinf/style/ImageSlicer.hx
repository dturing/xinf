/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.style;

import xinf.erno.ImageData;

class ImageSlicer {

#if flash9

    public static function slice( url:String, extension:String, l:Float, t:Float, r:Float, b:Float ) :Array<ImageData> {
        var master = ImageData.load( url+"."+extension );
        var images = new Array<ImageData>();

        var y:Float;
        var h:Float;
        
        y=0; h=t;
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:0., y:y, w:l, h:h } ) );
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:l, y:y, w:master.width-(r+l), h:h } ) );
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:master.width-r, y:y, w:r, h:h } ) );

        y=t; h=master.height-(t+b);
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:0., y:y, w:l, h:h } ) );
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:master.width-r, y:y, w:r, h:h } ) );

        y=master.height-b; h=b;
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:0., y:y, w:l, h:h } ) );
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:l, y:y, w:master.width-(r+l), h:h } ) );
        images.push( new xinf.flash9.ImageDataRegion( master, 
                    { x:master.width-r, y:y, w:r, h:h } ) );
        
        return images;
    }

#else true

    static var partNames:Array<String> = ["lt","t","rt","lc","rc","lb","b","rb"];
    
    public static function slice( url:String, extension:String, l:Float, t:Float, r:Float, b:Float ) :Array<ImageData> {
    
        var images = new Array<ImageData>();
        for( part in partNames ) {
            var i = ImageData.load( url+"."+part+"."+extension );
            images.push( i );
        }
        return images;
    }
    
#end

}
