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
import gst.Pipeline;
import xinf.inity.Texture;
import xinf.event.FrameEvent;
import xinf.erno.Runtime;

class VideoSource extends Texture {
	public var pipeline(default,null):Pipeline;
	
	public var duration(get_duration,null):Float;
	public var position(get_position,seekTo):Float;
	
	public function get_duration() :Float {
		return pipeline.duration();
	}
	public function get_position() :Float {
		return pipeline.position();
	}
	public function seekTo( to:Float ) :Float {
		pipeline.seek( to );
		return pipeline.position();
	}

	public function new( launch:String, ?w:Int, ?h:Int ) :Void {
		super();
		width=w; height=h;
		if( width==null ) width=320;
		if( height==null ) height=240;
		initialize( width, height );
		
		launch += " ! ffmpegcolorspace ! video/x-raw-rgb, width="+width+", height="+height+" ! memorysink sync=false";
		pipeline = new Pipeline( launch );

		Runtime.addEventListener( FrameEvent.ENTER_FRAME, step );
	}

	private function step(e:FrameEvent) :Void {
		var msg:{name:String} = pipeline.pollBus(0);
		while( msg!=null ) {
			// TODO: make this an iterator, and use a callback
			if( msg.name == "frame" && untyped msg.data != null ) {
				setData( untyped msg.data, {x:0,y:0}, {x:width,y:height} );
				frameAvailable( untyped msg.data );
			} else {
				trace("Unhandled GStreamer bus message: '"+msg.name );
			}
			
			msg = pipeline.pollBus(0);
		}
	}
}
