package xinf.ony.erno;

import xinf.erno.Renderer;

class Image extends xinf.ony.base.Image {
    
    override public function drawContents( g:Renderer ) :Void {
        if( bitmap==null ) {
            // "empty"
            g.setStroke( 1,0,0,1,1 );
            g.setFill( .5,.5,.5,.5 );
            g.rect( x, y, width, height );
        }
		if( width<=0 ) width = bitmap.width;
		if( height<=0 ) height = bitmap.height;
		
		g.setFill( 1,1,1,style.opacity );
		
		if( style.opacity > 0 || style.opacity==null ) {
			g.image( bitmap, {x:0.,y:0.,w:bitmap.width,h:bitmap.height}, {x:x,y:y,w:width,h:height} );
		}
     }
    
}
