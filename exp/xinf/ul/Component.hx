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
import xinf.event.GeometryEvent;

class Component extends xinf.style.StyleClassElement {
    public var constraints(getConstraints,null):LayoutConstraints;
    public function getConstraints() :LayoutConstraints {
        if( constraints==null ) {
            constraints = new LayoutConstraints(    
                new ComponentX(this), new ComponentY(this),
                new ComponentWidth(this), new ComponentHeight(this) );
        }
        return constraints;
    }
    
    public function new() {
        super();
    }
    
    public function resize( x:Float, y:Float ) :Void {
        var old = {x:size.x,y:size.y};
        super.resize(x,y);
        if( constraints!=null ) {
            if( x!=old.x ) {   
                constraints.getWidth().updateClients(x);
            }
            if( y!=old.y ) {   
                constraints.getHeight().updateClients(y);
            }
        }
    }
}
