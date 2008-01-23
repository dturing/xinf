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

import Xinf;
import xinf.inity.Texture;
import xinf.inity.ColorSpace;
import xinf.inity.gst.Pipeline;


class VideoSource extends Texture {
    public var pipeline(default,null):Pipeline;
    
    public var duration(get_duration,null):Float;
    public var position(get_position,seekTo):Float;
	
    public function get_duration() :Float {
        return pipeline.duration;
    }
    public function get_position() :Float {
        return pipeline.position;
    }
    public function seekTo( to:Float ) :Float {
        pipeline.seekTo( to );
        return pipeline.position;
    }

    public function new( launch:String, ?w:Int, ?h:Int ) :Void {
        super();
        if( w==null ) w=320;
        if( h==null ) h=240;
        width=w; height=h;
        initialize( w, w, h, RGBA );
        
        launch += " ! ffmpegcolorspace ! video/x-raw-rgb, depth=(int)24, bpp=(int)32, width="+width+", height="+height+" ! rgbatobgra ! nekobus name=\"output\" sync=true";
		trace("LAUNCH: "+launch );
        pipeline = new Pipeline( launch );

		pipeline.addEventListener( NekobusData.DATA, onData );
    }

    private function onData(e:NekobusData) :Void {
		if( e.element == "output" ) {
			frameData( e.buffer.data() );
		}
    }
    
    private function frameData( data:Dynamic ) :Void {
        setData( data, {x:0,y:0}, {x:Math.round(width),y:Math.round(height)}, Math.round(width), RGBA );
        frameAvailable( data );
    }
}
