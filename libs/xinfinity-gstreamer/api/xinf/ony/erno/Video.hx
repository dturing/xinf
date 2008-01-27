/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.xml.URL;
import xinf.erno.Renderer;
import xinf.erno.Paint;
import xinf.ony.traits.PreserveAspectRatioTrait;

#if neko
import xinf.inity.gst.VideoSource;
import xinf.event.ImageLoadEvent;

class Video extends xinf.ony.Video {

	var source:VideoSource;
	var srcElement:gst.Object;
	
	var pipeTest:xinf.inity.gst.Pipeline;
	
	public function new( ?traits:Dynamic ) :Void {
		super(traits);
	}

    override function set_href( v:String ) :String { 
		setTrait("href",v);
		applyHref();
        return href;
	}

	override public function onLoad() :Void {
		super.onLoad();
		applyHref();
	}
	
	function applyHref() {
		trace("video: apply href "+href );
		//source.pipeline.pause();
		//srcElement.set("location", href );
		//source.pipeline.play();
		
		//source = new VideoSource("videotestsrc",
		source = new VideoSource("gnomevfssrc name=src location=\""+href+"\" ! decodebin name=d ! queue ! audioconvert ! alsasink  d. ! queue" );
		srcElement = source.pipeline.findChild("src");
        source.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
    }

    private function dataChanged( e:ImageLoadEvent ) :Void {
        redraw();
    }

	override public function drawContents( g:Renderer ) :Void {

		if( source==null ) return;
		if( source.width==null || source.height==null ) return;

		if( width<=0 ) width = source.width;
		if( height<=0 ) height = source.height;
		
		var box = PreserveAspectRatioTrait.align( preserveAspectRatio,
			{ x:source.width, y:source.height }, { x:width, y:height } );

		g.setFill( SolidColor(1,1,1,opacity) );
		box.x+=x; box.y+=y;
		
		if( opacity > 0 || opacity==null ) {
			g.image( source, {x:0.,y:0.,w:source.width,h:source.height}, box );
		}
     }

	static function __init__() :Void {
		var svgns = "http://www.w3.org/2000/svg";
	
        xinf.xml.Document.addToBinding( svgns, "video", Video );
	}
}
#else true
class Video extends xinf.ony.Video {
}
#end