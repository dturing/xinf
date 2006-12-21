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

package xinf.ony;

import xinf.event.GeometryEvent;
import xinf.erno.Runtime;

/**
    Root represents the Runtime-default root Object, i.e., the Stage in Flash,
    the Document in JS, or the (main) Window in Xinfinity.
    <p>
        Root is "just" an <a href="Embed">Embed</a> Object that uses the 
        Runtime's default root to embed its display hierarchy. It also watches
        for STAGE_SCALED events to update it's size.
    </p>
**/
class Root extends Embed {
    
    /**
        Constructor; creates a new Root. This should only ever be called once
        for every Application (if you need multiple Roots, use <a href="Embed">Embed</a>).
        There is nothing checking this, so take care. If you instantiate an
        <a href="Application">Application</a>, the Root will be created for you,
        access it with Application.root.
    **/
    public function new() :Void {
        super( Runtime.runtime.getDefaultRoot() );
        Runtime.addEventListener( GeometryEvent.STAGE_SCALED, stageScaled );
    }

    private function stageScaled( e:GeometryEvent ) :Void {
        resize(e.x,e.y);
    }
    
}
