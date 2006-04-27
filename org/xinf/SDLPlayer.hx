package org.xinf;

import SDL;
import org.xinf.event.Event;
import org.xinf.event.MouseEvent;
import org.xinf.display.Stage;
import org.xinf.display.DisplayObject;
import org.xinf.geom.Point;
import org.xinf.render.IRenderer;
import org.xinf.render.GLRenderer;

class SDLPlayer {
    public var quit : Bool;
    public var buttonpress : Bool;

    private var root : Stage;
    private var width : Int;
    private var height : Int;
    private var mouseX : Int;
    private var mouseY : Int;
    private var currentOver : Array<DisplayObject>;
    
    private function ProcessEvents() {
        var e = SDL._NewEvent();
        while( SDL.PollEvent( e ) > 0 ) {
            var k = SDL.Event_type_get(e);
            
            switch( k ) {
                case SDL.QUIT:
                    trace("Quit");
                    quit = true;
                case SDL.KEYDOWN:
                    var ke = SDL.Event_key_get(e);
                    handleKeyboardEvent( ke, k );
                case SDL.KEYUP:
                    var ke = SDL.Event_key_get(e);
                    handleKeyboardEvent( ke, k );
                case SDL.MOUSEMOTION:
                    var me = SDL.Event_motion_get(e);
                    handleMouseMotionEvent( me, k );
                case SDL.MOUSEBUTTONDOWN:
                    var me = SDL.Event_button_get(e);
                    handleMouseEvent( me, k );
                case SDL.MOUSEBUTTONUP:
                    var me = SDL.Event_button_get(e);
                    handleMouseEvent( me, k );
                default:
                    trace("Event "+k);
            }
        }
    }
    
    private function handleKeyboardEvent( ke, k ) {
        var sym = SDL.KeyboardEvent_keysym_get(ke);
        var code = SDL.keysym_scancode_get(sym);
        var s = SDL.keysym_sym_get(sym);
        var name = SDL.GetKeyName(s);
        
        var up = "down";
        if( k==SDL.KEYUP ) up = "up";
        trace("Key "+name+" "+up );
    }

    private function handleMouseEvent( e, k ) {
        buttonpress = k == SDL.MOUSEBUTTONDOWN;
        var x = SDL.MouseButtonEvent_x_get(e);
        var y = SDL.MouseButtonEvent_y_get(e);

        var type:String = MouseEvent.MOUSE_UP;
        if( k == SDL.MOUSEBUTTONDOWN ) type = MouseEvent.MOUSE_DOWN;
        
        var e:MouseEvent = new MouseEvent( { 
            type: type,
            stageX: x,
            stageY: y
            } ); 
            
        dispatchToTargets( e, x, y );
    }
        
    private function dispatchToTargets( e:Event, x:Int, y:Int ) : Void {
        // find hits
        var targets:Array<DisplayObject> = root.getObjectsUnderPoint( new Point(x,height-y) );
        
        // root will handle by default
        if( 0==targets.length ) targets.push(root);
        
        // dispatch until a handler returns true 
        for( target in targets ) {
            e.target = target;
            if( target.dispatchEvent( e ) ) return;
        }
    }

    private function doOverOut( x:Float, y:Float ) {
        var targets:Array<DisplayObject> = root.getObjectsUnderPoint( new Point(x,height-y) );
        var out:Array<DisplayObject> = new Array<DisplayObject>();
        var over:Array<DisplayObject> = new Array<DisplayObject>();

        // FIXME: this is a bit inefficient?        
        for( t in targets ) {
            var found = false;
            for( old in currentOver ) {
                if( old == t ) {
                    found = true;
                }
            }
            if( !found ) {
                over.push(t);
            }
        }
        for(  old in currentOver ) {
            var found = false;
            for( t in targets ) {
                if( old == t ) {
                    found = true;
                }
            }
            if( !found ) {
                out.push(old);
            }
        }
        
        // send mouseout events
        var e:MouseEvent = new MouseEvent( { 
            type: MouseEvent.MOUSE_OUT,
            stageX: x,
            stageY: y
            } );
        for( target in out ) {
            e.target = target;
            target.dispatchEvent(e);
        }
        
        // send mouseover events
        var e:MouseEvent = new MouseEvent( { 
            type: MouseEvent.MOUSE_OVER,
            stageX: x,
            stageY: y
            } );
        for( target in over ) {
            e.target = target;
            target.dispatchEvent(e);
        }
        
        currentOver = targets;
    }

    private function handleMouseMotionEvent( e, k ) {
        mouseX = SDL.MouseMotionEvent_x_get(e);
        mouseY = SDL.MouseMotionEvent_y_get(e);
    }
    
    public function new( _root : Stage ) {
        root = _root;
        quit = buttonpress = false;
        width = 320;
        height = 240;
        mouseX = mouseY = -1;
        currentOver = new Array<DisplayObject>();
        if( SDL.Init( SDL.INIT_VIDEO ) < 0 ) {
            throw("SDL Video Initialization failed.");
        }
                
        if( SDL.SetVideoMode( width, height, 0, SDL.OPENGL ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }
    }
    
    public function iterate() : Bool {
        ProcessEvents();

        var e  = new Event( { type: Event.ENTER_FRAME } );
        e.propagate = true;
        root.dispatchEvent( e );            

        doOverOut( mouseX, mouseY );

        root.Render();

        SDL.GL_SwapBuffers();

        return( !quit );
    }
}
