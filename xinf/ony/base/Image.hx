package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import xinf.ony.URL;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

class Image extends ElementImpl {

	static var TRAITS:Hash<TraitDefinition>;
	static function __init__() {
		TRAITS = new Hash<TraitDefinition>();
		for( trait in [
			new FloatTrait("x",0.),
			new FloatTrait("y",0.),
			new FloatTrait("width",0.),
			new FloatTrait("height",0.),
			new StringTrait("xlink:href"),
		] ) { TRAITS.set( trait.name, trait ); }
	}

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Float); }
    function set_x( v:Float ) :Float { redraw(); return setTrait("x",v); }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Float); }
    function set_y( v:Float ) :Float { redraw(); return setTrait("y",v); }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Float); }
    function set_width( v:Float ) :Float { redraw(); return setTrait("width",v); }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Float); }
    function set_height( v:Float ) :Float { redraw(); return setTrait("height",v); }

    public var href(get_href,set_href):String;
    function get_href() :String { return getTrait("xlink:href",String); }
    function set_href( v:String ) :String { 
		setTrait("xlink:ref",v);
        var url:URL; var b;
		if( document!=null ) b = document.style.xmlBase;
        if( b!=null ) url = new URL(b).getRelativeURL( href );
        else url = new URL(href);
        trace("Load image: "+url );
        bitmap = load( url.toString() );

        redraw();
        return href;
	}

    public var bitmap(default,set_bitmap):ImageData;

    private function set_bitmap(v:ImageData) {
        // FIXME: if old bitmap, unregister...
        bitmap=v;
        bitmap.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        bitmap.addEventListener( ImageLoadEvent.LOADED, dataChanged );
        redraw();
        return bitmap;
    }
    
    private function dataChanged( e:ImageLoadEvent ) :Void {
        redraw();
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
