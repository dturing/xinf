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

import xinf.event.GeometryEvent;
import xinf.erno.Runtime;

class RootComponent extends Pane {
    public function new() :Void {
        super();
        Runtime.addEventListener( GeometryEvent.STAGE_SCALED, stageScaled );
    }

    public function setPrefSize( s:{x:Float,y:Float} ) :{x:Float,y:Float} {
        super.setPrefSize( s );
        return _prefSize;
    }
    
    function stageScaled( e:GeometryEvent ) :Void {
        resize( e.x, e.y );
        relayoutNeeded=true;
        scheduleTransform();
    }
}
