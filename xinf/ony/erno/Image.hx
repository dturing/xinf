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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import xinf.ony.URL;

/**
**/
class Image extends Object, implements xinf.ony.Image {
    
    public var x(default,set_x):Float;
    public var y(default,set_y):Float;
    public var width(default,set_width):Float;
    public var height(default,set_height):Float;
    public var href(default,set_href):String;
    
    private var img:ImageData;


    private function set_x(v:Float) {
        x=v; scheduleRedraw(); return x;
    }
    private function set_y(v:Float) {
        y=v; scheduleRedraw(); return y;
    }
    private function set_width(v:Float) {
        width=v; scheduleRedraw(); return width;
    }
    private function set_height(v:Float) {
        height=v; scheduleRedraw(); return height;
    }

    private function set_href(v:String) {
        href=v;
        var b = document.style.xmlBase;
        var url:URL;
        if( b!=null ) url = new URL(b).getRelativeURL( href );
        else url = new URL(href);
        
        trace("Load image: "+url );
        img = load( url.toString() );

        img.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        img.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        img.addEventListener( ImageLoadEvent.LOADED, dataChanged );
        
        scheduleRedraw();
        return href;
    }

    public function new() :Void {
        super();
        x=y=width=height=0;
    /*
        img = i;
        if( img.width!=null ) {
            size.x = img.width;
            size.y = img.height;
        }
        img.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
        img.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
        img.addEventListener( ImageLoadEvent.LOADED, dataChanged );
    */
    }
    
    private function dataChanged( e:ImageLoadEvent ) :Void {
        scheduleRedraw();
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

    override public function drawContents( g:Renderer ) :Void {
        if( img==null || img.width==null ) return;
        g.setFill( 1,1,1,1 );
        g.image( img, {x:0.,y:0.,w:img.width,h:img.height}, {x:x,y:y,w:width,h:height} );
     }
    
}
