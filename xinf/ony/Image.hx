/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; withot even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ony;

#if js
import js.Dom;
#end

/**
    Image is the xinfony Element that will display an (surprise!) Image.
    It's bounds rectangle, if not changed by your application's code, will be
    set to the image's native size (FIXME: is this already so for flash/js?).
    If you change the bounds, the image will be scaled.
**/
class Image extends Element {

    private var uri:String;
    private var _checkLoaded:Dynamic;
    
    #if neko
    private var _i:xinf.inity.Image;
    #end

    /**
        Constructor. The 'src' parameter is the key here: for xinfinity 
        and JavaScript, it is a (relative) URL path to the image file. 
        For Flash, it is the "linkage ID" of the image. Note that linkage
        IDs can contain slashes ('/'), so if you embed images properly 
        for flash, you can use the same src parameter for any runtime here.
    **/
    public function new( name:String, parent:Element, src:String ) :Void {
        uri = src;
        super( name, parent );
        
        autoSize = true;
        addEventListener( xinf.event.Event.LOADED, sizeKnown );
        
        #if flash
            postEvent( xinf.event.Event.LOADED, { w:_p._width, h:_p._height } );
        #else js
            untyped _p.onload=imageLoaded;
        #else neko
            postEvent( xinf.event.Event.LOADED, { w:_i.data.width, h:_i.data.height } );
        #end
    }
    
    private function sizeKnown( e:xinf.event.Event ) :Void {
        if( autoSize ) {
            bounds.setSize( e.data.w, e.data.h );
        }
//        trace("image "+this+" sizeKnown: "+e.data.w+"x"+e.data.h );
//        trace("  autosize "+autoSize+" bounds: "+bounds );
    }
    
    #if js
    private function imageLoaded( e:Dynamic ) :Void {
        postEvent( xinf.event.Event.LOADED, { w:untyped _p.offsetWidth, h:untyped _p.offsetHeight } );
    }
    #end
    
    override private function createPrimitive() :Dynamic {
        #if neko
            _i = new xinf.inity.Image( uri );
            return _i;
        #else js
            var i:js.HtmlDom = js.Lib.document.createElement("img");
            untyped i.src = uri;
            return i;
        #else flash
            _checkLoaded = checkLoaded;
      //      xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.ENTER_FRAME, _checkLoaded );
      
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.attachMovie(uri,name,parent._p.getNextHighestDepth());
            
      //      _p = parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
      //      _p.loadMovie( uri );
            return _p;
        #end
    }

    #if flash
        override private function onSizeChanged( e:xinf.event.Event ) :Void {
            if( !autoSize ) {
                _p._width  = Math.floor( e.data.width );
                _p._height = Math.floor( e.data.height );
            }
        }
        
        private function checkLoaded( e:xinf.event.Event ) :Void {
    		var loaded = true;
			if( ( _p.getBytesTotal() < 4 ) || ( _p.getBytesLoaded() != _p.getBytesTotal() ) ) loaded = false;
            if( loaded ) {
                xinf.event.EventDispatcher.removeGlobalEventListener( xinf.event.Event.ENTER_FRAME, _checkLoaded );
                postEvent( xinf.event.Event.LOADED, { w:_p._width, h:_p._height } );
            }
        }
    #end
}
