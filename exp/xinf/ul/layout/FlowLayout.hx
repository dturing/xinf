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

class Orientation {
    public function new();
    
    public function A(d:{x:Float,y:Float}):Float { throw("unimplemented"); return null; }
    public function B(d:{x:Float,y:Float}):Float { throw("unimplemented"); return null; }
    public function get(a:Float,b:Float):{x:Float,y:Float} { throw("unimplemented"); return null; }

    public function firstA(d:{l:Float,t:Float}):Float { throw("unimplemented"); return null; }
    public function firstB(d:{l:Float,t:Float}):Float { throw("unimplemented"); return null; }
    public function alignA(s:Style):Float { throw("unimplemented"); return null; }
    public function alignB(s:Style):Float { throw("unimplemented"); return null; }
}

class Vertical extends Orientation {
    public function A(d:{x:Float,y:Float}):Float { return d.y; }
    public function B(d:{x:Float,y:Float}):Float { return d.x; }
    public function get(a:Float,b:Float):{x:Float,y:Float} { return({x:b,y:a}); }
    public function firstA(d:{l:Float,t:Float}):Float { return d.t; }
    public function firstB(d:{l:Float,t:Float}):Float { return d.l; }
    public function alignA(s:Style):Float { return( s.get("vAlign",0.) ); }
    public function alignB(s:Style):Float { return( s.get("hAlign",0.) ); }
}

class Horizontal extends Orientation {
    public function A(d:{x:Float,y:Float}):Float { return d.x; }
    public function B(d:{x:Float,y:Float}):Float { return d.y; }
    public function get(a:Float,b:Float):{x:Float,y:Float} { return({x:a,y:b}); }
    public function firstA(d:{l:Float,t:Float}):Float { return d.l; }
    public function firstB(d:{l:Float,t:Float}):Float { return d.t; }
    public function alignA(s:Style):Float { return( s.get("hAlign",0.) ); }
    public function alignB(s:Style):Float { return( s.get("vAlign",0.) ); }
}



class FlowLayout implements Layout {
    public static var VERTICAL:Orientation = new Vertical();
    public static var HORIZONTAL:Orientation = new Horizontal();
    public static var Horizontal3:FlowLayout = new FlowLayout( FlowLayout.HORIZONTAL, 3 );
    
    public var pad:Float; // FIXME: no way to trigger relayout...
    public var o:Orientation;
    
    public function new( ?o:Orientation, ?pad:Float ) :Void {
        if( pad==null ) pad=0;
        this.pad = pad;
        if( o==null ) o=VERTICAL;
        this.o = o;
    }
    
    public function layoutContainer( parent:Container ) {
        var first = o.firstA(parent.style.padding) + o.firstA(parent.style.border);
        var acc = first;
        var bPad = o.firstB(parent.style.padding) + o.firstB(parent.style.border);
        var max = 0.;
        var positions = new Array<{x:Float,y:Float}>();
        
        for( c in parent.children ) {
            positions.push( o.get( acc, bPad ) );
            
            var s = c.clampSize( c.prefSize );
            c.resize( s.x, s.y ); // somewhere else?
            
            acc += o.A(c.size) + pad;
            max = Math.max( o.B(c.size), max );
        }
        var total = acc-(first+pad);
    
        // parent alignment
        var s = parent.removePadding(parent.size);
        var ashift = ( o.A( s ) - total ) * o.alignA( parent.style );
        var bshift = ( o.B( s ) - max   ) * o.alignB( parent.style );
        for( c in parent.children ) {
            var p = positions.shift();
            var cshift = ( max - o.B( c.size ) ) * o.alignB( c.style );
            var q = o.get( o.A(p)+ashift, o.B(p)+bshift+cshift );
            c.moveTo( q.x, q.y );
        }

        parent.setPrefSize( o.get(total,max) );
    }
}
