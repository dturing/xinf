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
import xinf.erno.Renderer;

class Root extends Object {
    
    private var root:NativeContainer;
    
    public function new( ?o:NativeContainer ) :Void {
        super();
        root = o;
        if( root==null ) root = Runtime.runtime.getDefaultRoot();
        
        Runtime.addEventListener( GeometryEvent.STAGE_SCALED, stageScaled ); // FIXME hmmm...
    }

    public function draw( g:Renderer ) :Void {
        g.startNative( root );
        for( child in children ) {
            g.showObject( child._id );
        }
        g.endNative();
    }
    
    private function stageScaled( e:GeometryEvent ) :Void {
        resize(e.x,e.y);
    }
    
}
