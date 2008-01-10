/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.flash9;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import flash.display.Loader;
import flash.display.Bitmap;
import flash.events.Event;
import flash.net.URLRequest;

class ExternalImageData extends ImageData {
    
    private var loader:Loader;
    
    public function new( url:String ) :Void {
        super();
        loader = new Loader();
        loader.load( new URLRequest(url) );
        loader.contentLoaderInfo.addEventListener( Event.COMPLETE, img_loaded );
    }
    
    private function img_loaded( e:flash.events.Event ) :Void {
        bitmapData = (cast(loader.content,Bitmap)).bitmapData;
        width = Math.round(bitmapData.width); height = Math.round(bitmapData.height);
        loaded( bitmapData );
    }
    
}
