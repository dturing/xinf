/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.js;

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
