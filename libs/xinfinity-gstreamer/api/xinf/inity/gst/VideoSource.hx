/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

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

    public function new( launch:String ) :Void {
        super();
        
        launch += " ! ffmpegcolorspace ! video/x-raw-rgb, depth=(int)24, bpp=(int)32 ! nekobus name=\"output\" sync=true";
		trace("Gstreamer Pipeline: "+launch );
        pipeline = new Pipeline( launch );

		pipeline.addEventListener( NekobusData.DATA, onData );
    }

    private function onData(e:NekobusData) :Void {
		if( e.element == "output" && e.buffer!=null ) {
		
			var caps = e.buffer.caps();
			var w:Int = caps.width; var h:Int = caps.height;
			if( w!=width || h!=height ) {
				width=w; height=h;
				trace("video size: "+w+"x"+h );
				initialize( Math.round(width), Math.round(width), Math.round(height), RGBA );
			}
		
			frameData( e.buffer.data() );
		}
    }
    
    private function frameData( data:Dynamic ) :Void {
        setData( data, {x:0,y:0}, {x:Math.round(width),y:Math.round(height)}, Math.round(width), RGBA );
        frameAvailable( data );
    }
}
