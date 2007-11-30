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

import xinf.erno.Renderer;
import xinf.erno.ImageData;

class CenteredImage implements Fill {

    var image:ImageData;
    var name:String;
    
    public function new( name:String ) :Void {
        image = ImageData.load( name+".png" );
        this.name = name;
    }
    
    public function draw( g:Renderer, s:{x:Float,y:Float} ) :Void {
        var xo = (s.x-image.width)/2;
        var yo = (s.y-image.height)/2;
        g.image( image, {x:0.,y:0.,w:image.width,h:image.height}, {x:xo, y:yo, w:image.width, h:image.height} );
    }

    public function toString() :String {
        return("ScaledImageFill '"+name+"'");
    }
}
