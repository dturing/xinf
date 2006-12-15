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

class Manager {
	private var objects:IntHash<Object>;
	private var changed:IntHash<Object>;

	public function new() :Void {
		objects = new IntHash<Object>();
		changed = new IntHash<Object>();

		// redraw changed objects each frame
		Runtime.addEventListener( FrameEvent.ENTER_FRAME,
			redrawChanged );

		// dispatch some events to targets (xinferno only knows about IDs, not Objects 
		Runtime.addEventListener( MouseEvent.MOUSE_DOWN, dispatchToTarget );
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
	
	public function redrawChanged( e:FrameEvent ) :Void {
		var ch = changed;
		changed = new IntHash<Object>();
		var somethingChanged:Bool = false;
		
		var g:Renderer = Runtime.renderer;
		for( id in ch.keys() ) {
			ch.get(id).draw( g );
			somethingChanged = true;
		}
		if( somethingChanged ) Runtime.runtime.changed();
	}
	
	private function find( id:Int ) :Object {
		return objects.get(id);
	}
}