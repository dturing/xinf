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

import xinf.ul.FocusManager;
import xinf.event.KeyboardEvent;
import xinf.event.MouseEvent;

/**
    Widget base class.
    Takes care of Keyboard Focus.
**/
class Widget extends Pane {
    
    public var focusable:Bool;

    public function new() :Void {
        super();
        focusable = true;
        FocusManager.register(this);
        
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownWidget );
        addStyleClass("Pane");
    }
    
    // FIXME: child classes have their own onMouseDown, which is not really override.
    // is Widget the class that "highlevels" mouseevents towards onClick, onDrag etc? probably!
    private function onMouseDownWidget( e:MouseEvent ) :Void {
        FocusManager.setFocus( this );
    }
    
    public function focus() :Bool {
        if( !focusable ) {
            return false;
        }
        addStyleClass(":focus");
        return true;
    }

    public function blur() :Void {
        removeStyleClass(":focus");
    }
    
}
