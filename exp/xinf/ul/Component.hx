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
import xinf.ony.Container;
import xinf.ul.layout.LayoutConstraints;
import xinf.ul.layout.ComponentValue;
import xinf.value.Value;
import xinf.style.Style;
import xinf.event.GeometryEvent;

class Component extends xinf.style.StyleClassElement {
    var pad :{ l:Value, t:Value, r:Value, b:Value };
    var preferredSize :{ width:Value, height:Value };
    
    public var constraints(getConstraints,null):LayoutConstraints;
    public function getConstraints() :LayoutConstraints {
        if( constraints==null ) {
            constraints = new LayoutConstraints(    
                new ComponentX(this), new ComponentY(this),
                new ComponentWidth(this,Value.sum(preferredSize.width,pad.l,pad.r)), 
                new ComponentHeight(this,Value.sum(preferredSize.height,pad.l,pad.r)) );
        }
        return constraints;
    }
    
    public function new() {
        preferredSize = {
            width:Value.constant(0),
            height:Value.constant(0)
            };
        pad = { 
            l:Value.constant(0),
            t:Value.constant(0),
            r:Value.constant(0),
            b:Value.constant(0) };
        super();
    }

    override public function applyStyle( s:Style ) :Void {
        super.applyStyle(s);
        pad.l.value = s.padding.l+s.border.l;
        pad.t.value = s.padding.t+s.border.t;
        pad.r.value = s.padding.r+s.border.r;
        pad.b.value = s.padding.b+s.border.b;
    }

    public function resize( x:Float, y:Float ) :Void {
        var old = {x:size.x,y:size.y};
        super.resize(x,y);
        if( constraints!=null ) {
            if( x!=old.x ) {   
                constraints.getWidth().setValue(x);
            }
            if( y!=old.y ) {   
                constraints.getHeight().setValue(y);
            }
        }
    }
}
