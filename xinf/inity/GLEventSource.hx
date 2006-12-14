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

package xinf.inity;

import opengl.GLUT;

import xinf.event.SimpleEventDispatcher;
import xinf.event.Event;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;

import xinf.erno.Keys;

class GLEventSource {
	private var frame:Int;
	private var runtime:XinfinityRuntime;

	public function new( runtime:XinfinityRuntime ) :Void {
		frame=0;
		this.runtime = runtime;
	}
	
	public function attach() :Void {
		GLUT.setKeyboardFunc( keyPress );
		GLUT.setSpecialFunc( specialKeyPress );
		GLUT.setMouseFunc( mouseButton );
		GLUT.setMotionFunc( mouseMotion );
		GLUT.setPassiveMotionFunc( mouseMotion );
	}
	
	public function keyPress( key:Int, x:Int, y:Int ) :Void {
		var k = Keys.get(key);
		if( k==null ) k = String.fromCharCode(key);
		runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, key, k ) );
		runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, key, k ) );
	}
	public function specialKeyPress( key:Int, x:Int, y:Int ) :Void {
		var k = Keys.get(key);
		runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, key, k ) );
		runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, key, k ) );
	}

	public function mouseButton( button:Int, state:Int, x:Int, y:Int ) :Void {
		var target:Int = runtime.findIdAt(x,y);
		button+=1;
		
        if( button == 4 || button == 5 ) {
            if( state==1 ) {
                var delta:Int = -1; // up;
                if( button==5 ) delta = 1; // down
				
				runtime.postEvent( new ScrollEvent( ScrollEvent.SCROLL_STEP, delta, target ));
            }
            return;
        }

		if( state==0 ) {
			runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_DOWN, x, y, button, target ) );
		} else {
			runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_UP, x, y, button, target ) );
		}
	}

	public function mouseMotion( x:Int, y:Int ) :Void {
		var target:Int = runtime.findIdAt(x,y);
		
		runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_MOVE, x, y, -1, target ) );
	}
 
	public function toString() :String {
		return("GLEventSource");
	}
}
