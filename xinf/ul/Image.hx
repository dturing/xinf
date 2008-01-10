/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

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
class Image extends Component {
    
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
        g.image( img, {x:0.,y:0.,w:img.width,h:img.height}, {x:0.,y:0.,w:size.x,h:size.y} );
     }
    
}
