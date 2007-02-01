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

package xinf.ul;

import xinf.ony.Object;
import xinf.style.Style;
import xinf.event.GeometryEvent;

class Component extends xinf.style.StyleClassElement {
    public var __parentSizeListener:Dynamic;

    public var prefSize(getPrefSize,null):{x:Float,y:Float};
    var _prefSize:{x:Float,y:Float};

    public function new() :Void {
        _prefSize = { x:.0, y:.0 };
        super();
    }

    public function getPrefSize() :{x:Float,y:Float} {
        return( _prefSize );
    }
    
    public function setPrefSize( n:{x:Float,y:Float} ) :{x:Float,y:Float} {
        var s = addPadding(n);
        if( _prefSize==null || s.x!=_prefSize.x || s.y!=_prefSize.y ) {
            _prefSize = s;
            postEvent( new GeometryEvent( GeometryEvent.PREF_SIZE_CHANGED, size.x, size.y ) );
        }
        return( _prefSize );
    }

    override public function applyStyle( s:Style ) {
        var p = removePadding( _prefSize );
        super.applyStyle(s);
        setPrefSize( p );
    }

    /* maybe...
    public function getMinimumSize() :{x:Float,y:Float} {
        return( {x:0.,y:0.} );
    }
    public function getMaximumSize() :{x:Float,y:Float} {
        return( {x:Math.POSITIVE_INFINITY,y:Math.POSITIVE_INFINITY} );
    }
    override public function resize( x:Float, y:Float ) :Void {
        super.resize( x, y );
        
        innerSize = {
            x:x - (style.padding.l+style.padding.r+style.border.l+style.border.r),
            y:y - (style.padding.t+style.padding.b+style.border.t+style.border.b) };
        innerPos = {
            x:style.padding.l+style.border.l,
            y:style.padding.t+style.border.t };
    }
    public function resizeInner( x:Float, y:Float ) :Void {
        resize( x + style.padding.l+style.padding.r + style.border.l+style.border.r, 
                y + style.padding.t+style.padding.b + style.border.t+style.border.b );
    }
    */

}
