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
import xinf.ul.ComponentContainer;
import xinf.ul.Pane;
import xinf.value.Value;
import xinf.style.Style;

class LayoutContainer extends ComponentContainer<Component> {
    var spacing :{ h:Value, v:Value };
    var pad :{ l:Value, t:Value, r:Value, b:Value };
    
    public function new() :Void {
        spacing = {
            h:Value.constant(3),
            v:Value.constant(3)
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
    
    public function layout() :Void {
    }
}
