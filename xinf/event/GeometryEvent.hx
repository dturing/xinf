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

package xinf.event;

/**
    GeometryEvent is used to propagate information about changes
    in position or size of some Element.
**/
class GeometryEvent extends Event<GeometryEvent> {
    
    static public var STAGE_SCALED     = new EventKind<GeometryEvent>("stageScaled");
    
    public var x:Float; // x coordinate of position or width
    public var y:Float; // y coordinate of position or height
    
    public function new( _type:EventKind<GeometryEvent>, _x:Float, _y:Float ) {
        super(_type);
        x=_x; y=_y;
    }

    public function toString() :String {
        return( ""+type+"("+x+","+y+")" );
    }
    
}