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
import xinf.event.EventKind;

#if js
import js.Dom;
#end

/**
    Image is the xinfony Element that will display an (surprise!) Image.
    It's bounds rectangle, if not changed by your application's code, will be
    set to the image's native size (FIXME: is this already so for flash/js?).
    If you change the bounds, the image will be scaled.
	
	TODO: does IMAGE_LOADED really have to be an event?
**/
class Image extends Element {
    private var uri:String;
    private var _checkLoaded:Dynamic;
    
    #if neko
    private var _i:xinf.inity.Bitmap;
	#else flash
	private var _i:flash.MovieClip;
    #end

    /**
        Constructor. The 'src' parameter is the key here: for xinfinity 
        and JavaScript, it is a (relative) URL path to the image file. 
        For Flash, it is the "linkage ID" of the image. Note that linkage
        IDs can contain slashes ('/'), so if you embed images properly 
        for flash, you can use the same src parameter for any runtime here.
    **/
    public function new( name:String, parent:Element, ?src:String ) :Void {
        super( name, parent );
        addEventListener( GeometryEvent.IMAGE_LOADED, sizeKnown );
        
		if( src != null ) load( src );
    }
    
    private function sizeKnown( e:GeometryEvent ) :Void {
        if( autoSize ) {
            bounds.setSize( e.x, e.y );
        }
//        trace("image "+this+" sizeKnown: "+e.data.w+"x"+e.data.h );
//        trace("  autosize "+autoSize+" bounds: "+bounds );
    }
    
    #if js
    private function imageLoaded( e:Dynamic ) :Void {
        postEvent( new GeometryEvent( GeometryEvent.IMAGE_LOADED, this,
					untyped _p.offsetWidth, untyped _p.offsetHeight ) );
    }
    #end
    
    override private function createPrimitive() :Primitive {
        #if neko
            _i = new xinf.inity.Bitmap();
            return _i;
        #else js
            var i:js.HtmlDom = js.Lib.document.createElement("img");
            return i;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
			return parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
		#end
    }

	public function load( src:String ) :Void {
		if( src == uri ) return;
		
		uri = src;
		#if js 
			untyped _p.src = uri;
		#else neko
			_i.load( uri );
		#else flash
			// delete old
			if( _i != null ) _i.removeMovieClip();
			// load from asset library
            _i = _p.attachMovie(uri,name,1);
			
			// loadMovie (external; doesnt work for PNGs!)
			//_p.loadMovie( uri );
            //_checkLoaded = checkLoaded;
			//xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.ENTER_FRAME, _checkLoaded );
		#end

        #if flash
            postEvent( new GeometryEvent( GeometryEvent.IMAGE_LOADED, this, _p._width, _p._height ) );
        #else js
            untyped _p.onload=imageLoaded;
        #else neko
			if( _i.data != null ) 
				postEvent( new GeometryEvent( GeometryEvent.IMAGE_LOADED, this, _i.data.width, _i.data.height ) );
        #end
	}

    #if flash
        override private function onSizeChanged( e:GeometryEvent ) :Void {
            if( !autoSize ) {
                _p._width  = Math.floor( e.x );
                _p._height = Math.floor( e.y );
            }
        }
        /* FIXME
        private function checkLoaded( e:xinf.event.Event ) :Void {
    		var loaded = true;
			if( ( _p.getBytesTotal() < 4 ) || ( _p.getBytesLoaded() != _p.getBytesTotal() ) ) loaded = false;
            if( loaded ) {
                xinf.event.EventDispatcher.removeGlobalEventListener( xinf.event.Event.ENTER_FRAME, _checkLoaded );
                postEvent( xinf.event.Event.LOADED, { w:_p._width, h:_p._height } );
            }
        }
		*/
    #end
}
