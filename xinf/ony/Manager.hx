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

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.FrameEvent;
import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;

/**
    Xinfony creates one singleton Manager object as a static private member of Object.
    <p>
    It keeps a list (actually an IntHash) of all Objects,
    keeps track of changes to their contents or transformation
    and re-draws and re-transforms those that changed, once for each frame
    and using <a href="../erno/Runtime.html">Runtime</a>'s global renderer.
    <p></p>
    It also dispatches MouseEvent.MOUSE_DOWN and ScrollEvent.SCROLL_STEP to the
    Object whose ID is given in the Event (xinf.erno only knows about IDs, and
    has no reference to the actual object).
    </p>
    <p>
    All public functions on Manager are for use from <a href="Object.html">Object</a>,
    there should be no need to "manually" register any object.
    Use Object.scheduleRedraw() to mark an object as changed.
    </p>
**/
class Manager {
    
    private var objects:IntHash<Object>;
    private var changed:IntHash<Object>;
    private var moved:IntHash<Object>;

    public function new() :Void {
        objects = new IntHash<Object>();
        changed = new IntHash<Object>();
        moved   = new IntHash<Object>();

        // redraw changed objects each frame
        Runtime.addEventListener( FrameEvent.ENTER_FRAME,
            redrawChanged );

        // dispatch some events to targets (xinferno only knows about IDs, not Objects 
        Runtime.addEventListener( MouseEvent.MOUSE_DOWN, dispatchToTarget );
        Runtime.addEventListener( MouseEvent.MOUSE_OVER, dispatchToTarget );
        Runtime.addEventListener( MouseEvent.MOUSE_OUT, dispatchToTarget );
        Runtime.addEventListener( ScrollEvent.SCROLL_STEP, dispatchToTarget );
    }

    private function dispatchToTarget( e:Dynamic ) :Void {
        if( e.targetId != null ) {
            var target = find( e.targetId );
            if( target != null ) target.postEvent( e );
        }
    }
    
    public function register( id:Int, o:Object ) :Void {
        // TODO #if debug, check if already set.
        objects.set(id,o);
    }

    public function unregister( id:Int) :Void {
        // TODO #if debug, check if set.
        objects.remove(id);
    }

    public function objectChanged( id:Int, o:Object ) :Void {
        changed.set(id,o);
    }

    public function objectMoved( id:Int, o:Object ) :Void {
        moved.set(id,o);
    }

    private function redrawChanged( e:FrameEvent ) :Void {
        var somethingChanged:Bool = false;
        var g:Renderer = Runtime.renderer;
        
        var ch = changed;
        changed = new IntHash<Object>();
        for( id in ch.keys() ) {
            ch.get(id).draw( g );
            somethingChanged = true;
        }

        var ch = moved;
        moved = new IntHash<Object>();
        for( id in ch.keys() ) {
            ch.get(id).reTransform( g );
            somethingChanged = true;
        }

        if( somethingChanged ) Runtime.runtime.changed();
    }
    
    private function find( id:Int ) :Object {
        return objects.get(id);
    }
    
}
