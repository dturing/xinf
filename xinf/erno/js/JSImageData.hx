/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.js;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import js.Dom;

class JSImageData extends ImageData {
    
    private var img:js.Image;
    
    public function new( url:String ) :Void {
        super();
        this.url = url;
        img = cast(js.Lib.document.createElement("img"));
        img.onload = js_loaded;
        img.src = url;
    }
    
    private function js_loaded( e:Event ) :Void {
        width = img.width; height=img.height;
        postEvent( new ImageLoadEvent( ImageLoadEvent.LOADED, this ) );
    }
    
}
