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

package xinf.ul.layout;

import xinf.ul.Component;
import xinf.ul.Container;
import xinf.style.Style;

enum Border {
    Center;
    North;
    East;
    South;
    West;
}

class BorderLayout extends ConstrainedLayout<Border>, implements Layout {
    var pad:Float;
    
    public function new( ?pad:Float ) :Void {
        super();
        if( pad==null ) pad=0;
        this.pad = pad;
    }
    
    public function layoutContainer( parent:Container ) {
        var N:Component;
        var E:Component;
        var S:Component;
        var W:Component;
        var C:Component;
        
        for( c in parent.children ) {
            switch( getConstraints( c ) ) {
                case North:
                    N=c;
                case East:
                    E=c;
                case South:
                    S=c;
                case West:
                    W=c;
                case Center:
                    C=c;
                default:
            }
        }

        var p = parent.removePadding( parent.size );
        var tl = parent.innerTopLeft();
        var n=tl.y;
        var w=tl.x;
        var s=0.;
        var e=0.;
        
        if( N!=null ) {
            var s = N.clampSize( {x:p.x, y:N.prefSize.y} );
            n += s.y;
            N.resize( s.x, s.y );
            N.moveTo( tl.x, tl.y );
        }
        if( S!=null ) {
            var sz = S.clampSize( {x:p.x, y:S.prefSize.y} );
            s = sz.y;
            S.resize( sz.x, sz.y );
            S.moveTo( tl.x, (tl.y+p.y) - s );
        }
        if( W!=null ) {
            var s = W.clampSize( {x:W.prefSize.x, y:(tl.y+p.y) - (n+s)} );
            w += s.x;
            W.resize( s.x, s.y );
            W.moveTo( tl.x, n );
        }
        if( E!=null ) {
            var s = E.clampSize( {x:E.prefSize.x, y:(tl.y+p.y) - (n+s)} );
            e = s.x;
            E.resize( s.x, s.y );
            E.moveTo( (tl.x+p.x) - e, n );
        }
        if( C!=null ) {
            C.moveTo( w, n );
            C.resize( (tl.x+p.x) - (w+e), (tl.y+p.y) - (n+s) );
        }
    }
}
