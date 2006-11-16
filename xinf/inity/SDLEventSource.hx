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

import xinf.event.SimpleEventDispatcher;
import xinf.event.Event;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.FrameEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;

//import xinf.ony.FocusManager;
//import xinf.ony.Root;

class SDLEventSource {
	private var frame:Int;
	private var runtime:XinfinityRuntime;

	public function new( runtime:XinfinityRuntime ) :Void {
		frame=0;
		this.runtime = runtime;
	}

    public function processEvents() :Void {
        var e = SDL._NewEvent();
        while( SDL.PollEvent( e ) > 0 ) {
            var k = SDL.Event_type_get(e);
            
            switch( k ) {
                case SDL.QUIT:
		    		runtime.postEvent( new SimpleEvent( SimpleEvent.QUIT ) );
                    
                case SDL.KEYDOWN:
                    handleKeyboardEvent( SDL.Event_key_get(e), k );
                case SDL.KEYUP:
                    handleKeyboardEvent( SDL.Event_key_get(e), k );
					
                case SDL.MOUSEMOTION:
                    handleMouseMotionEvent( SDL.Event_motion_get(e), k );
                case SDL.MOUSEBUTTONDOWN:
                    handleMouseEvent( SDL.Event_button_get(e), k );
                case SDL.MOUSEBUTTONUP:
                    handleMouseEvent( SDL.Event_button_get(e), k );
                    
                case SDL.VIDEORESIZE:
					var re = SDL.Event_resize_get(e);
					runtime.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, 
						SDL.ResizeEvent_w_get(re), 
						SDL.ResizeEvent_h_get(re) ) );
                    
                case SDL.ACTIVEEVENT:
                    // todo: mouseout on any overe'd item
					runtime.changed();
					
                case SDL.VIDEOEXPOSE:
					runtime.changed();
					
                default:
                    trace("Event "+k);
            }
        }
	
		// post enter_frame event
		runtime.postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
    }

    private function handleKeyboardEvent( ke, k ) :Void {
        var sym = SDL.KeyboardEvent_keysym_get(ke);
        var code = SDL.keysym_scancode_get(sym);
        var s = SDL.keysym_sym_get(sym);
        var name = SDL.GetKeyName(s);
        
		var str = new String("");
        untyped str.__s = name;
        untyped str.length = 1;
        
        var type = KeyboardEvent.KEY_DOWN;
        if( k==SDL.KEYUP ) type = KeyboardEvent.KEY_UP;
		
		var mods = SDL.GetModState();
		
		// FIXME: key events are global?
        runtime.postEvent( new KeyboardEvent( type,
				SDL.keysym_unicode_get(sym), 
				str,
				mods&(SDL.KMOD_LSHIFT|SDL.KMOD_RSHIFT) > 0,
				mods&(SDL.KMOD_LALT|SDL.KMOD_RALT) > 0,
				mods&(SDL.KMOD_LCTRL|SDL.KMOD_RCTRL) > 0
			) );
    } 

    private function handleMouseEvent( e, k ) :Void {
        var x = SDL.MouseButtonEvent_x_get(e);
        var y = SDL.MouseButtonEvent_y_get(e);
        var button = SDL.MouseButtonEvent_button_get(e);
		var target:Int = runtime.findIdAt(x,y);
        
        if( button == 4 || button == 5 ) {
            if( k == SDL.MOUSEBUTTONUP ) {
                var delta:Int = -1; // up;
                if( button==5 ) delta = 1; // down
				
				runtime.postEvent( new ScrollEvent( ScrollEvent.SCROLL_STEP, delta, target ));
            }
            return;
        }
		
		if( k == SDL.MOUSEBUTTONDOWN ) {
			runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_DOWN, x, y, button, target ) );
		} else {
			runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_UP, x, y, button, target ) );
		}
    }

    private function handleMouseMotionEvent( e, k ) :Void {
        var x = SDL.MouseMotionEvent_x_get(e);
        var y = SDL.MouseMotionEvent_y_get(e);
		var target:Int = 0; //runtime.findIdAt(x,y); // FIXME: performance!
		
		// FIXME: target
		runtime.postEvent( new MouseEvent( 
			MouseEvent.MOUSE_MOVE,
			Math.round(x), Math.round(y), -1, target ) );
    }
     
	public function toString() :String {
		return("SDLEventSource");
	}
}
