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

package xinf.svg;

import xinf.svg.Link;

/**
    SVG Display: displays an SVG Document, follows triggered links.
**/

class Display extends Group {
    var doc:Element;
    var currentUrl:String;

    public function new() :Void {
        super();
        addEventListener( LinkEvent.FOLLOW_LINK, onLink );
    }
    
    public function onLink( e:LinkEvent ) :Void {
        trace( e );
        load( e.url );
    }

    public function load( url:String ) :Void {
        if( doc!=null ) {
            detach( doc );
        }
        
        if( !urlProtocol.match(url) && currentUrl!=null ) {
            var base = currentUrl;
            if( !StringTools.endsWith( base, "/" ) ) {
                base = base.substr( 0, base.lastIndexOf("/") );
            }
            trace("base: "+base+", nu: "+url );
            url = base+"/"+url;
        }
        
        doc = loadDocument( url );
        if( doc != null ) {
            currentUrl = url;
            attach( doc );
        } else {
            currentUrl = null;
        }
    }
    
    public static var urlProtocol = ~/^([a-z]+):\/\/(.*)/;
    public static function loadDocument( url:String ) :Element {
        if( !urlProtocol.match(url) ) urlProtocol.match("file://"+url);
        var data:String;
        try {
            switch( urlProtocol.matched(1) ) {
                case "file":
                    #if neko // neko handles file:// specially, flash/js just try to load the file via usual ("http") mechanism.
                        data = neko.io.File.getContent(urlProtocol.matched(2));
                    #else
                        data = haxe.Http.request(url);
                    #end
                case "http":
                    data = haxe.Http.request(url);
                default:
                    throw "unknown protocol '"+urlProtocol.matched(1)+"'";
            }
            
            var xml = Xml.parse( data );
            var doc = new xinf.svg.Document();
            doc.fromXml( xml.firstElement() );
            return doc;
        } catch( e:Bool ) { // FIXME Dynamic ) {
            throw "Error loading '"+url+"': "+e;
        }
        return null;
    }
}
