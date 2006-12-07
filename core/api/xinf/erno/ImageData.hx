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

package xinf.erno;

import xinf.event.SimpleEventDispatcher;
import xinf.event.ImageLoadEvent;

class ImageData extends SimpleEventDispatcher {
	#if neko
		// texture id and size, size must be 2^n
		public var texture:Int;
		public var twidth:Int;
		public var theight:Int;
	#else err
		// js will use URL, flash dunno yet (asset id? movieclip to clone?)
	#end

    public var width(default,null):Int; // maybe not public?
    public var height(default,null):Int; // maybe not public?

	public function frameAvailable( ?data:Dynamic, ?pos:haxe.PosInfos ) :Void {
		postEvent( new ImageLoadEvent( ImageLoadEvent.FRAME_AVAILABLE, this, data ), pos );
	}
	private function partLoaded( ?pos:haxe.PosInfos ) :Void {
		postEvent( new ImageLoadEvent( ImageLoadEvent.PART_LOADED, this ), pos );
	}
	private function loaded( ?data:Dynamic, ?pos:haxe.PosInfos ) :Void {
		postEvent( new ImageLoadEvent( ImageLoadEvent.LOADED, this ), pos );
	}
}
