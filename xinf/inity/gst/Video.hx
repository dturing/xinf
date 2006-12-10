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

package xinf.inity.gst;

import xinf.ony.Object;
import xinf.erno.ImageData;
import xinf.erno.DrawingInstruction;
import xinf.erno.Renderer;
import xinf.event.ImageLoadEvent;

class Video extends Object {
	public var img:ImageData;

	public function new( img:ImageData ) :Void {
		super();
		this.img = img;
		img.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, frameAvailable );
//			img = new xinf.inity.gst.VideoSource(launch,w,h);
	}
	
	private function frameAvailable( e:ImageLoadEvent ) :Void {
		scheduleRedraw();
	}
	
	public function drawContents( g:Renderer ) :Void {
		g.draw( Image( img, {x:0,y:0,w:img.width,h:img.height}, {x:position.x,y:position.y,w:size.x,h:size.y} ) );
	}
}