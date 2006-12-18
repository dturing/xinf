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

package xinf.js;

import xinf.erno.SimpleRuntime;
import xinf.erno.Renderer;
import xinf.event.FrameEvent;

class JSRuntime extends SimpleRuntime {
	
	public static var defaultRoot:NativeContainer;
	private var frame:Int;
	private var _eventSource:JSEventSource;
	
	public function new() :Void {
		super();
		_eventSource = new JSEventSource(this);
		frame=0;
	}
	
	override public function getDefaultRoot() :NativeContainer {
		if( defaultRoot==null ) {
			defaultRoot = js.Lib.document.createElement("div");
			js.Lib.document.body.appendChild(defaultRoot);
		}
		return defaultRoot;
	}
	
	override public function run() :Void {
		_eventSource.rootResized(null);
 		untyped window.setInterval("xinf.erno.Runtime.getRuntime().step()",1000/25);
   	}
   	
	public function step() :Void {
		postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
	}
	
}