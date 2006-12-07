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
import xinf.event.FrameEvent;
import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;
import xinf.erno.Runtime;

class Root extends Object {
	public static var root:Root;
	
	public function new() :Void {
		if( root!=null ) throw("There can only be one Root.");
		super();
		_id = Runtime.renderer.getRootId();
		root = this;
		
		Runtime.addEventListener( GeometryEvent.STAGE_SCALED, stageScaled );

		// redraw changed objects each frame
		Runtime.addEventListener( FrameEvent.ENTER_FRAME,
			function( e:FrameEvent ) {
				Object.redrawChanged( Runtime.renderer );
			} );
			
		// dispatch some events to targets (xinferno only knows about IDs, not Objects 
		Runtime.addEventListener( MouseEvent.MOUSE_DOWN, dispatchToTarget );
		Runtime.addEventListener( ScrollEvent.SCROLL_STEP, dispatchToTarget );
	}
	
	private function dispatchToTarget( e:Dynamic ) :Void {
		if( e.targetId != null ) {
			var target = Object.findObjectById( e.targetId );
			if( target != null ) target.postEvent( e );
		}
	}
	
	private function stageScaled( e:GeometryEvent ) :Void {
		resize(e.x,e.y);
	}
}
