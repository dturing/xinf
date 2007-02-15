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

import xinf.event.Event;
import xinf.event.EventKind;

/**
    ComponentSizeEvent is used to propagate information about changes
    in size of some Component.
**/
class ComponentSizeEvent extends Event<ComponentSizeEvent> {
    
    static public var PREF_SIZE_CHANGED= new EventKind<ComponentSizeEvent>("prefSizeChanged");
    
    public var x:Float; // width
    public var y:Float; // height
    public var component:Component;
    
    public function new( _type:EventKind<ComponentSizeEvent>, _x:Float, _y:Float, _c:Component ) {
        super(_type);
        x=_x; y=_y;
        component = _c;
    }

    public function toString() :String {
        return( ""+type+"("+x+","+y+")" );
    }
    
}