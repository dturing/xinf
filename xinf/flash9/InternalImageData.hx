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

package xinf.flash9;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import flash.display.Loader;
import flash.display.Bitmap;
import flash.events.Event;
import flash.net.URLRequest;

class InternalImageData extends ImageData {
    
    private var loader:Loader;
    
    public function new( url:String ) :Void {
        super();
        /* FIXME
            this surely isn't beautifuly, but there seems to be no way
            to import assets as Bitmaps or even BitmapDatas directly
            with swfmill... if you can tell me how, please do!
        */
        var className = url.split(".").join("_").split("/").join(".");
        var cl = Type.resolveClass( className );
        if( cl==null ) throw("Cannot find Asset '"+url+"' (class '"+className+"')");
        var o:flash.display.MovieClip = Type.createInstance( cl, [] );
        var b = new flash.display.BitmapData( Math.floor(o.width), Math.floor(o.height), true, 0 );
        b.draw( o );
        bitmapData = b;
        width = Math.round(bitmapData.width); height = Math.round(bitmapData.height);
        loaded( bitmapData );
    }
    
}
