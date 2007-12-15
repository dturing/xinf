package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Paint;

class Image extends xinf.ony.base.Image {
    
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
		
		g.setFill( SolidColor(1,1,1,opacity) );
		
		if( opacity > 0 || opacity==null ) {
			g.image( bitmap, {x:0.,y:0.,w:bitmap.width,h:bitmap.height}, {x:x,y:y,w:width,h:height} );
		}
     }
    
}
