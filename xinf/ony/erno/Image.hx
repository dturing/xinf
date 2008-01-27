/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.xml.URL;
import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import xinf.erno.Renderer;
import xinf.erno.Paint;
import xinf.ony.traits.PreserveAspectRatioTrait;

class Image extends xinf.ony.Image {

    public var bitmap(default,set_bitmap):ImageData;

    override function set_href( v:String ) :String { 
		setTrait("href",v);
		resolve();
        return href;
	}

    private function set_bitmap(v:ImageData) {
        // FIXME: if old bitmap, unregister...
        bitmap=v;
        bitmap.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.LOADED, dataLoaded );
        redraw();
        return bitmap;
    }
    
    private function dataLoaded( e:ImageLoadEvent ) :Void {
		dataChanged(e);
		postEvent(e);
    }
	
    private function dataChanged( e:ImageLoadEvent ) :Void {
        redraw();
    }

	override public function onLoad() :Void {
		super.onLoad();
		resolve();
	}
	
	function resolve() :Void {
		var url:URL; var b=base;
//		trace("load img "+href+" base "+b+", in "+this );
		if( b!=null ) url = new URL(b).getRelativeURL( href );
		else url = new URL(href);
		
		try {
			bitmap = load( url.toString() );
		} catch(e:Dynamic) {
			trace( e );
		}
		redraw();
	}

    public static function load( url:String ) :ImageData {
		return ImageData.load( url );
    }
    
    override public function drawContents( g:Renderer ) :Void {
		if( bitmap==null ) {
            // "empty"
            g.setStroke( SolidColor(1,0,0,1), 1 );
            g.setFill( SolidColor(.5,.5,.5,.5) );
            g.rect( x, y, width, height );
			return;
        }

		if( width<=0 ) width = bitmap.width;
		if( height<=0 ) height = bitmap.height;
		
		var box = PreserveAspectRatioTrait.align( preserveAspectRatio,
			{ x:bitmap.width, y:bitmap.height }, { x:width, y:height } );

		g.setFill( SolidColor(1,1,1,opacity) );
		box.x+=x; box.y+=y;
		
		if( opacity > 0 || opacity==null ) {
			g.image( bitmap, {x:0.,y:0.,w:bitmap.width,h:bitmap.height}, box );
		}
     }

	override public function toString() :String {
		return("xinf.ony.erno.Image("+href+","+bitmap.width+"x"+bitmap.height+")");
	}

}
