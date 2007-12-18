/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.ImageData;

class ScaledImageFill implements Fill {

    var image:ImageData;
    var name:String;
    var inset:Float;
    
    public function new( name:String, ?inset:Float ) :Void {
        image = ImageData.load( name+".png" );
        if( inset==null ) inset=0;
        this.inset = inset;
        this.name = name;
    }
    
    public function draw( g:Renderer, s:{x:Float,y:Float} ) :Void {
        var i2 = 2*inset;
        g.image( image, {x:0.,y:0.,w:image.width,h:image.height}, {x:inset, y:inset,w:s.x-i2, h:s.y-i2} );
    }

    public function toString() :String {
        return("ScaledImageFill '"+name+"'");
    }
}
