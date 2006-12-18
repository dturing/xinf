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

class ExternalImageData extends ImageData {
	
	private var loader:Loader;
	
	public function new( url:String ) :Void {
		super();
		loader = new Loader();
		loader.load( new URLRequest(url) );
		loader.contentLoaderInfo.addEventListener( Event.COMPLETE, img_loaded );
	}
	
	private function img_loaded( e:flash.events.Event ) :Void {
		bitmap = cast(loader.content,Bitmap);
		postEvent( new ImageLoadEvent( ImageLoadEvent.LOADED, this ) );
	}
	
}
