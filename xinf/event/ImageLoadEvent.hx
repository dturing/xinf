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

package xinf.event;
import xinf.erno.ImageData;
import xinf.event.EventKind;
import xinf.event.Event;
import xinf.event.EventDispatcher;

/**
	
**/
class ImageLoadEvent extends Event<ImageLoadEvent> {
	
	static public var PART_LOADED = new EventKind<ImageLoadEvent>("imagePartLoaded");
	static public var LOADED = new EventKind<ImageLoadEvent>("imageLoaded");
	static public var FRAME_AVAILABLE = new EventKind<ImageLoadEvent>("imageFrameAvailable");

	public var image:ImageData;
	public var data:Dynamic;
	
	public function new( _type:EventKind<ImageLoadEvent>, image:ImageData, ?data:Dynamic ) {
		super(_type);
		this.image = image;
		this.data = data;
	}
	
}
