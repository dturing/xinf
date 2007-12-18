/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
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
