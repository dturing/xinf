/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Paint;
import xinf.ony.traits.PreserveAspectRatioTrait;

class Image extends xinf.ony.Image {
    
    override public function drawContents( g:Renderer ) :Void {
		if( bitmap==null ) {
            // "empty"
            g.setStroke( SolidColor(1,0,0,1), 1 );
            g.setFill( SolidColor(.5,.5,.5,.5) );
            g.rect( x, y, width, height );
			return;
        }

		if( width<=0 ) width = bitmap.width;
		if( height<=0 ) height = bitmap.height;
		
		var box = PreserveAspectRatioTrait.align( preserveAspectRatio,
			{ x:bitmap.width, y:bitmap.height }, { x:width, y:height } );

		g.setFill( SolidColor(1,1,1,opacity) );
		box.x+=x; box.y+=y;
		
		if( opacity > 0 || opacity==null ) {
			g.image( bitmap, {x:0.,y:0.,w:bitmap.width,h:bitmap.height}, box );
		}
     }
    
}
