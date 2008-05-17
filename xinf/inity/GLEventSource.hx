/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity;

import opengl.GLFW;

import xinf.event.SimpleEventDispatcher;
import xinf.event.Event;
import xinf.event.EventKind;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;
import xinf.event.UIEvent;

import xinf.erno.Keys;

class GLEventSource {
    
    private var frame:Int;
    private var runtime:XinfinityRuntime;
    private var currentOver:Int;
	private var currentDown:Int;
	private var wheel:Int;

    public function new( runtime:XinfinityRuntime ) :Void {
        frame=0;
        this.runtime = runtime;
    }
    
    public function attach() :Void {
        GLFW.setKeyFunction( handleKey );
        GLFW.setCharFunction( handleChar );
        GLFW.setMouseButtonFunction( mouseButton );
        GLFW.setMousePosFunction( mouseMotion );
		GLFW.setMouseWheelFunction( mouseWheel );
    }
    
    public function handleKey( key:Int, down:Int ) :Void {
        var k = Keys.get(key);
        if( k==null ) return;
//            k = String.fromCharCode(key).toLowerCase();
			
		if( down>0 ) postKeyPress( k, key );
        else postKeyRelease( k );
    }

    public function handleChar( char:Int, down:Int ) :Void {
		var k = String.fromCharCode(char);
		if( down>0 ) postKeyPress( k, char );
        else postKeyRelease( k );
    }

    public function postKeyPress( key:String, ?code:Int ) :Void {
		var shift = (GLFW.getKey( GLFW.KEY_LSHIFT ) + GLFW.getKey( GLFW.KEY_RSHIFT ))>0;
		var alt =   (GLFW.getKey( GLFW.KEY_LALT   ) + GLFW.getKey( GLFW.KEY_RALT ))>0;
		var ctrl =  (GLFW.getKey( GLFW.KEY_LCTRL  ) + GLFW.getKey( GLFW.KEY_RCTRL ))>0;
		
        runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, code, key, shift, alt, ctrl ) );
    }

    public function postKeyRelease( key:String ) :Void {
        runtime.postEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, 0, key ) );
    }

    public function mouseButton( button:Int, state:Int ) :Void {
		var pos = GLFW.getMousePosition();
		
        var target:Int = runtime.findIdAt(pos.x,pos.y);
        button+=1;

		var shift = (GLFW.getKey( GLFW.KEY_LSHIFT ) + GLFW.getKey( GLFW.KEY_RSHIFT ))>0;
		var alt =   (GLFW.getKey( GLFW.KEY_LALT   ) + GLFW.getKey( GLFW.KEY_RALT ))>0;
		var ctrl =  (GLFW.getKey( GLFW.KEY_LCTRL  ) + GLFW.getKey( GLFW.KEY_RCTRL ))>0;
		
        if( state==1 ) {
            runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_DOWN, pos.x, pos.y, button, target, shift, alt, ctrl ) );
			currentDown = target;
        } else {
            runtime.postEvent( new MouseEvent( MouseEvent.MOUSE_UP, pos.x, pos.y, button, target, shift, alt, ctrl ) );
			if( target==currentDown ) {
				runtime.postEvent( new UIEvent( UIEvent.ACTIVATE, target ) );
			}
			currentDown==null;
        }
    }

    private function postMouseEventTo( x:Int, y:Int, type:EventKind<MouseEvent>, targetId:Int ) :Void {
        runtime.postEvent( new MouseEvent( type, x, y, 0, targetId ) );
    }
    
    public function mouseMotion( x:Int, y:Int ) :Void {
        var targetId:Int = runtime.findIdAt(x,y);
        if( targetId != currentOver ) {
            if( currentOver!=null ) {
                postMouseEventTo( x, y, MouseEvent.MOUSE_OUT, currentOver );
            }
            postMouseEventTo( x, y, MouseEvent.MOUSE_OVER, targetId );
            currentOver = targetId;
        } else 
            postMouseEventTo( x, y, MouseEvent.MOUSE_MOVE, targetId );
    }

    public function mouseWheel( wpos:Int ) :Void {
		if( wheel==null ) {
			wheel = wpos;
			return;
		}
		var delta = wheel-wpos;
		wheel=wpos;
		
		var pos = GLFW.getMousePosition();
        var targetId:Int = runtime.findIdAt(pos.x,pos.y);
		var e = new ScrollEvent( ScrollEvent.SCROLL_STEP, delta, targetId );
		runtime.postEvent( e );
    }

    public function toString() :String {
        return("GLEventSource");
    }
    
}
