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

package xinf.svg.ext;

import xinf.svg.Rect;
import xinf.svg.Element;

/**
    SVG Load: loads/watches/embeds another SVG document
**/

class Load extends Rect {
    var doc:Element;
    var currentUrl:String;
    var live:Bool;
    var lastChanged:Date;
    var watcher:Dynamic;

    public function new() :Void {
        super();
    }
    
    public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        var url = xml.get("load");
        live = getBooleanProperty(xml,"live",false);
        if( url!=currentUrl ) load( url );
    }
    
    public static var urlProtocol = ~/^([a-z]+):\/\/(.*)/;
    public function load( url:String ) :Void {
        if( doc!=null ) {
            detach( doc );
        }
        
        /*
        if( !urlProtocol.match(url) && currentUrl!=null ) {
            var base = currentUrl;
            if( !StringTools.endsWith( base, "/" ) ) {
                base = base.substr( 0, base.lastIndexOf("/") );
            }
            trace("base: "+base+", nu: "+url );
            url = base+"/"+url;
        }
        */

            var stat = neko.FileSystem.stat(url);
            lastChanged = stat.mtime;

        doc = loadDocument( url );
        if( doc != null ) {
            currentUrl = url;
            doc.moveTo( x, y );
        //    doc.resize( w, h );
            attach( doc );
        } else {
            currentUrl = null;
        }
        
        if( live ) {
            var stat = neko.FileSystem.stat(url);
            lastChanged = stat.mtime;
        
            if( watcher!=null ) xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, watcher );
            watcher = checkReload;
            xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, watcher );
        }
    }
 
    public function checkReload( e:xinf.event.FrameEvent ) :Void {
        if( e.frame % 25 == 0 ) {
            var stat = neko.FileSystem.stat(currentUrl);
            if( lastChanged.getTime() < stat.mtime.getTime() ) {
                trace("reload: "+currentUrl );
                load( currentUrl );
            }
        }
    }

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
