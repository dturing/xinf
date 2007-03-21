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

import xinf.erno.Renderer;
import xinf.geom.Matrix;
import xinf.style.StyleClassElement;

/**
    Simple Scaling container element.
**/

class Scale extends Container {
    
    public function new() :Void {
        super();
    }

    // FIXME once transforms are elaborate

    public function getMatrix() :Matrix {
        return new xinf.geom.Matrix()
            .setIdentity()
            .setTranslation(position.x,position.y)
            .setScale(size.x,size.y);    
    }
            
    override public function reTransform( g:Renderer ) :Void {
        var m = getMatrix();
        g.setTransform( _id, m.tx, m.ty, m.a, m.b, m.c, m.d );
    }

    override public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        q = getMatrix().applyInverse(q);
        return q;
    }
    
    override public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = getMatrix().apply(p);
        if( parent!=null ) q = parent.localToGlobal(q);
        return q;
    }

}
