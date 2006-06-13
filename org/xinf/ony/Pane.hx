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

package org.xinf.ony;

/**
    A Pane is a xinfony Element that renders a rectangle in its background color.
    Pane can be useful by itself, but is also base class for other visible Elements
    that can have a background.
**/
class Pane extends Element {
    private var bgColor:org.xinf.ony.Color;

    /**
        if true, contents will be cropped to the Pane's bounds. if false, they will be visible
        in any case.
    **/
    public var crop(get_crop,set_crop):Bool;
    private var _crop:Bool;
    #if flash
        private var _crop_mc:flash.MovieClip;
    #end

    /** Constructor. **/
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
        _crop = false;

        #if js
            _p.style.overflow = "visible";
        #end
    }
    
    private function createPrimitive() :Dynamic {
        #if neko
            return new org.xinf.inity.Box();
        #else js
            return js.Lib.document.createElement("div");
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
        #end
    }
    
    private function get_crop() :Bool {
        return _crop;
    }
    private function set_crop( val:Bool ) :Bool {
        _crop=val;
        #if js
            _p.style.overflow = 
                if( _crop ) "hidden";
                else "visible";
        #else flash
            if( _crop ) {
                _crop_mc = makeMask();
                _p.setMask( _crop_mc );
            } else {
                if( _crop_mc != null ) _crop_mc.removeMovieClip(); // FIXME: untested
                _crop_mc = null;
            }
        #else neko
            untyped _p.crop = _crop;
            _p.changed();
        #end
        return _crop;
    }
    
    #if flash
    private function makeMask() :flash.MovieClip {
        var clip:flash.MovieClip = _crop_mc;
        if( clip == null ) clip = parent._p.createEmptyMovieClip( "mask", parent._p.getNextHighestDepth() );
        
        _p.setMask( clip );
        
        var w:Int = Math.round(bounds.width);
        var h:Int = Math.round(bounds.height);
        clip.clear();
        clip.beginFill( 0xaa0000 );
        clip.moveTo( 0, 0 );
        clip.lineTo( w, 0 );
        clip.lineTo( w, h );
        clip.lineTo( 0, h );
        clip.endFill();
        clip._x = bounds.x;
        clip._y = bounds.y;
        return clip;
    }
    
    private function onSizeChanged( e:org.xinf.event.Event ) :Void {
        if( _crop ) {
            _crop_mc = makeMask();
        }
        super.onSizeChanged( e );
    }
    private function onPositionChanged( e:org.xinf.event.Event ) :Void {
        if( _crop ) {
            _crop_mc._x = e.data.x;
            _crop_mc._y = e.data.y;
        }
        super.onPositionChanged( e );
    }
    #end

    /** Set the background color to the Color specified. **/
    public function setBackgroundColor( bg:org.xinf.ony.Color ) :Void {
        bgColor = bg;
        
        #if neko
            _p.bgColor = bgColor;
            _p.changed();
        #else js
            _p.style.background = bgColor.toRGBString();
        #else flash
            scheduleRedraw();
        #end
    }
    
    #if flash
        private function redraw() :Void {
            super.redraw();

            var x:Int = 0;
            var y:Int = 0;
            var w:Int = Math.round(bounds.width);
            var h:Int = Math.round(bounds.height);

            _p.clear();
            _p.beginFill( bgColor.toRGBInt(),  100 );

    //            _p.lineStyle( style.borderWidth, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );

            _p.moveTo( x, y );
            _p.lineTo( w, y );
            _p.lineTo( w, h );
            _p.lineTo( x, h );
//            _p.lineTo( x, y );
            _p.endFill();
        }
    #end
}
