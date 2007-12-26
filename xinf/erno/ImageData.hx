/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.event.SimpleEventDispatcher;
import xinf.event.ImageLoadEvent;

/**
	DOCME: out of date!
	
    ImageData represents the data of a bitmap image. It can be passed to a
    <a href="Renderer.html">Renderer</a>'s [image()] function to draw (part of) an image.
    <p>
        ImageData is also a SimpleEventDispatcher and dispatches
        <a href="../event/ImageLoadEvent.html">ImageLoadEvents</a>
    </p>
**/
class ImageData extends SimpleEventDispatcher {
    #if neko
        /**
            Xinfinity only: the OpenGL-ID of the texture that contains the image data.
        **/
        public var texture(default,null):Int;
        
        /**
            Xinfinity only: the allocated width of the texture that contains the image data,
            must be a power of two.
        **/
        public var twidth(default,null):Int;

        /**
            Xinfinity only: the allocated height of the texture that contains the image data,
            must be a power of two.
        **/
        public var theight(default,null):Int;
    #else js
        public var url(default,null):String;
    #else flash9
        public var bitmapData(default,null):flash.display.BitmapData;
    #end

    /**
        The width of the image, set only after the image is (at least partly) loaded.
    **/
    public var width(default,null):Float;
    
    /**
        The height of the image, set only after the image is (at least partly) loaded.
    **/
    public var height(default,null):Float;

    private function frameAvailable( ?data:Dynamic, ?pos:haxe.PosInfos ) :Void {
        postEvent( new ImageLoadEvent( ImageLoadEvent.FRAME_AVAILABLE, this, data ), pos );
    }
    
    private function partLoaded( ?pos:haxe.PosInfos ) :Void {
        postEvent( new ImageLoadEvent( ImageLoadEvent.PART_LOADED, this ), pos );
    }
    
    private function loaded( ?data:Dynamic, ?pos:haxe.PosInfos ) :Void {
        postEvent( new ImageLoadEvent( ImageLoadEvent.LOADED, this ), pos );
    }
    
    /**
        load this ImageData from the given URL. What kind of URLs are accepted
        differs from runtime to runtime:
        <ul>
            <li>Xinfinity: [file://] for local files, [http://] for remote files,
                or [resource://] for images embedded as haXe resources.
                Xinfinity uses the gdk-pixbuf library to decode image data,
                so it supports any of the formats supported by that, most notably,
                JPEG, PNG and GIF.</li>
            <li>Flash9: any URL accepted for flash.display.Loader,
                but the url must return an Bitmap image. Additionally,
                [resource://] urls are accepted to load images from
                the asset library of the current SWF (not from haXe resources!)</li>
            <li>JavaScript: any URL accepted for normal image URLs.</li>
        </ul>
    **/
    public static function load( url:String ) :ImageData {
        #if neko
            return( xinf.inity.Texture.newByName( url ) );
        #else js
            return( new xinf.erno.js.JSImageData(url) );
        #else flash
            if( StringTools.startsWith( url, "library://" ) ) {
                return( new xinf.erno.flash9.InternalImageData(url.substr(10)) );
            } else {
                return( new xinf.erno.flash9.ExternalImageData(url) );
            }
        #else err
        #end
    }
	
    #if flash9
	public static function getRegion( image:ImageData, region:{ x:Float, y:Float, w:Float, h:Float } ) :ImageData {
			return( new xinf.erno.flash9.ImageDataRegion( image, region ) );
	}
    #end
}
