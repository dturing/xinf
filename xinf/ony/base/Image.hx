/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;

import xinf.type.URL;
import xinf.type.Length;

import xinf.traits.TraitDefinition;
import xinf.traits.StringTrait;
import xinf.traits.LengthTrait;

class Image extends ElementImpl {

	static var tagName = "image";

	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		width:new LengthTrait(),
		height:new LengthTrait(),
		href:new StringTrait(), // FIXME proper namespaces
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }

    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Length).value; }
    function set_width( v:Float ) :Float { setTrait("width",new Length(v)); redraw(); return v; }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Length).value; }
    function set_height( v:Float ) :Float { setTrait("height",new Length(v)); redraw(); return v; }
	
    public var href(get_href,set_href):String; // TODO xlink namespace
    function get_href() :String { return getTrait("href",String); }
    function set_href( v:String ) :String { 
		setTrait("href",v);
		resolve();
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

	override public function onLoad() :Void {
		super.onLoad();
		resolve();
	}
	
	function resolve() :Void {
		var url:URL; var b=base;
		trace("load img "+href+" base "+b+", in "+this );
		if( b!=null ) url = new URL(b).getRelativeURL( href );
		else url = new URL(href);
		bitmap = load( url.toString() );
		redraw();
	}

    public static function load( url:String ) :ImageData {
		return ImageData.load( url );
    }

}
