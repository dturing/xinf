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

/**
    Simple Vertical Box packing element.
**/

class VBox extends ComponentContainer {
    
    public var padding:Float;

    public function new() :Void {
        super();
    }
    
    public function dolayout() :Void {
    	
        var pad = style.padding;
        if( pad==null ) pad = { l:0., t:0., r:0., b:0. };
        
        var y:Float = pad.t;
        var w:Float = 0;
        for( child in children ) {
            child.moveTo( pad.l, y );
            y+=child.size.y+pad.b;
            w = Math.max( w, child.size.x );
        }
        size = { x:w+pad.l+pad.r, y:y };
        
        /*
        zb: TODO see xinf.ul.Pane for comments
        
        var pad = style.padding;
        if( pad==null ) pad = { l:0., t:0., r:0., b:0. };
        
        var border = style.border;
        if( border==null ) border = { l:0., t:0., r:0., b:0. };
        
        var y:Float = border.t+pad.t;
        var w:Float = 0;
        for( child in children ) {
            child.moveTo( border.l+pad.l, y );
            y+=child.size.y+pad.b;
            w = Math.max( w, child.size.x );
        }
        size = { x:w+pad.l+pad.r+border.l+border.r, y:y+border.b };
        */
    }
    
    public function attach( child:Component ) :Void {
        super.attach(child);
        dolayout();
    }
    
    public function resize( x:Float, y:Float ) :Void {
        super.resize(x,y);
        dolayout();
    }
    
}
