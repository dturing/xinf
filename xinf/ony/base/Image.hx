package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import xinf.ony.URL;

class Image extends ElementImpl {

    public var x(default,set_x):Float;
    public var y(default,set_y):Float;
    public var width(default,set_width):Float;
    public var height(default,set_height):Float;
    public var href(default,set_href):String;
    
    public var bitmap(default,set_bitmap):ImageData;

    private function set_x(v:Float) {
        x=v; redraw(); return x;
    }
    private function set_y(v:Float) {
        y=v; redraw(); return y;
    }
    private function set_width(v:Float) {
        width=v; redraw(); return width;
    }
    private function set_height(v:Float) {
        height=v; redraw(); return height;
    }

    private function set_href(v:String) {
        var url:URL;
        href=v;
		var b;
		if( document!=null ) b = document.style.xmlBase;
        if( b!=null ) url = new URL(b).getRelativeURL( href );
        else url = new URL(href);
        trace("Load image: "+url );
        bitmap = load( url.toString() );

        redraw();
        return href;
    }

    private function set_bitmap(v:ImageData) {
        // FIXME: if old bitmap, unregister...
        bitmap=v;
        bitmap.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.LOADED, dataChanged );
        redraw();
        return bitmap;
    }

    public function new() :Void {
        super();
        x=y=0;
		width=height=0;
    }
    
    private function dataChanged( e:ImageLoadEvent ) :Void {
        redraw();
    }
   
    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        width = getFloatProperty(xml,"width");
        height = getFloatProperty(xml,"height");
		href = xml.get("xlink:href");
    }

    public static function load( url:String ) :ImageData {
        #if neko
            return( xinf.inity.Texture.newByName( url ) );
        #else js
            return( new xinf.js.JSImageData(url) );
        #else flash
            if( StringTools.startsWith( url, "library://" ) ) {
                return( new xinf.flash9.InternalImageData(url.substr(10)) );
            } else {
                return( new xinf.flash9.ExternalImageData(url) );
            }
        #else err
        #end
    }

}
