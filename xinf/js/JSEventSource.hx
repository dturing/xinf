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

package xinf.ony.js;

import xinf.event.SimpleEventDispatcher;
import xinf.ony.RuntimeEventSource;
import xinf.ony.event.FrameEvent;

class JSEventSource extends SimpleEventDispatcher, implements RuntimeEventSource {
	private var frame:Int;

	public function new() :Void {
		super();
		frame=0;
	}
	
	public function run() :Void {
		untyped window.setInterval( step, 1000/25 );
	}
	
	public function step() :Void {
		postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, this, frame++ ) );
	}
}
