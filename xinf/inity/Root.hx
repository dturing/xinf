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

import SDL;
import xinf.event.Event;

class Profiler {
    private var data:Hash<Int>;
    private var last:Int;
    private var laps:Int;
    
    private function now() :Int {
        return 0; // FIXME
//        return CPtr.util_msec();
    }
    
    public function new() {
        data = new Hash<Int>();
        last = now();
        laps = 0;
    }
    
    public function check( name:String ) :Void {
        var _now:Int = now();
    //    trace( ""+_now+"\t-"+last+"="+(_now-last) );
        var acc:Int = data.get(name);
        if( acc == null ) acc = 0;
        acc += _now-last;
        data.set(name,acc);
        last = _now;
    }
    
    public function lap() :Void {
        check("end of lap");
        laps++;
        /* continuous dumps
        if( laps % 25 == 0 ) {
            dump();
        }
        */
    }
    
    public function dump() :Void {
        var s:String = "Profile "+laps+" laps:\n";
        for( check in data.keys() ) {
            // FIXME: pretty stupid formatting.
            var v = (data.get(check)*1000)/laps;
            v = Math.round(v)/1000;
            s += "\t";
            if( v<100 ) s+=" ";
            if( v<10 ) s+=" ";
            s += v+"\t:"+ check + "\n";
        }
        trace(s);
    }
}


class Root extends Stage {
    /* the one player root. SOMEONE MUST SET THIS. FIXME*/
    public static var root:Root = null;

    private var quit : Bool;
    public var mouseX : Int;
    public var mouseY : Int;
    private var buttonpress : Bool;
    private var objectUnderMouse : Object;

    private static var selectBuffer = CPtr.uint_alloc(64);
    private static var view = CPtr.int_alloc(4);

    
    public function new( w:Int, h:Int ) :Void {
        super( w, h );
        
        quit = false;
        mouseX = -1;
        mouseY = -1;
        buttonpress = false;
        objectUnderMouse = null;

        if( SDL.Init( SDL.INIT_VIDEO ) < 0 ) {
            throw("SDL Video Initialization failed.");
        }

        SDL.EnableUNICODE(1);
        SDL.EnableKeyRepeat( SDL.DEFAULT_REPEAT_DELAY, SDL.DEFAULT_REPEAT_INTERVAL );

        xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.QUIT, doQuit );

        resize( w, h );
    }
    
    public function doQuit( e:xinf.event.Event ) {
        quit=true;
    }

    override public function resize( w:Int, h:Int ) : Void {
        super.resize(w,h);

        SDL.GL_SetAttribute ( SDL.GL_ALPHA_SIZE , 8 );
        if( SDL.SetVideoMode( Math.floor(width), Math.floor(height), 32, SDL.OPENGL | SDL.RESIZABLE | SDL.GL_DOUBLEBUFFER ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }

        GL.PixelStorei( GL.UNPACK_ALIGNMENT, 4 );

        GL.Enable( GL.BLEND );
        GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
//        GL.BlendFunc( GL.SRC_ALPHA_SATURATE, GL.ONE );
        
        GL.ShadeModel( GL.FLAT );
  //      GL.Enable( GL.POLYGON_SMOOTH );
  //      GL.Hint( GL.POLYGON_SMOOTH_HINT, GL.NICEST );
      }
    
    public function run() : Bool {
        var p:Profiler = new Profiler();
        var changed:Bool;

        resize(Math.round(width),Math.round(height));

        while( !quit ) {
            changed=false;
        
          p.check("sleep");
            
            xinf.event.EventDispatcher.postGlobalEvent( Event.ENTER_FRAME, { } );
            processEvents();
            Event.processQueue();
          p.check("Event.queue");

            if( Object.cacheChanged() ) changed=true;
            doOverOut();
            if( Object.cacheChanged() ) changed=true;
          p.check("xinfinity cache, over/out");
            
            if( changed ) {
            startFrame();
                render();
            endFrame();
            }
          p.check("render");

            // check for OpenGL errors
            var e:Int = GL.GetError();
            if( e > 0 ) {
                throw( "OpenGL error "+GLU.ErrorString(e) );
            }

          p.lap();
            
            // FIXME: proper timing, neko idle func?
            neko.Sys.sleep(0.01);
        }
        p.dump();
        return true;
    }

    /* ------------------------------------------------------
       SDL Event functions
       ------------------------------------------------------ */
    
    public function processEvents() :Void {
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
                    
                case SDL.VIDEORESIZE:
                    var re = SDL.Event_resize_get(e);
                    resize( SDL.ResizeEvent_w_get(re), SDL.ResizeEvent_h_get(re) );
                    
                case SDL.ACTIVEEVENT:
                    //trace("active event");
                    // todo: mouseout on any overe'd item
                case SDL.VIDEOEXPOSE:
                    changed();
                default:
                    trace("Event "+k);
            }
        }
    }

    private function handleKeyboardEvent( ke, k ) :Void {
        var sym = SDL.KeyboardEvent_keysym_get(ke);
        var code = SDL.keysym_scancode_get(sym);
        var s = SDL.keysym_sym_get(sym);
        var name = SDL.GetKeyName(s);
        
        var str = new String("");
        untyped str.__s = name;
        untyped str.length = 1;
        
        var type = Event.KEY_DOWN;
        if( k==SDL.KEYUP ) type = Event.KEY_UP;
        
        trace("Key "+name+" "+type+", keysym "+s+" code "+code+" unicode "+SDL.keysym_unicode_get(sym) );
        xinf.event.EventDispatcher.postGlobalEvent( type, { key:str } );
    }

    private function handleMouseEvent( e, k ) :Void {
        buttonpress = k == SDL.MOUSEBUTTONDOWN;
        var x = SDL.MouseButtonEvent_x_get(e);
        var y = SDL.MouseButtonEvent_y_get(e);
        var button = SDL.MouseButtonEvent_button_get(e);
        
        if( button == 4 || button == 5 ) {
            if( k == SDL.MOUSEBUTTONUP ) {
                var delta:Int = -1; // up;
                if( button==5 ) delta = 1; // down
                if( objectUnderMouse != null )
                    objectUnderMouse.postEvent( Event.SCROLL_STEP, { delta:delta } );
                else
                    xinf.event.EventDispatcher.postGlobalEvent( Event.SCROLL_STEP, { delta:delta } );
            }
            return;
        }

        var type:String = Event.MOUSE_UP;
        if( k == SDL.MOUSEBUTTONDOWN ) type = Event.MOUSE_DOWN;
        
        if( objectUnderMouse != null )
            objectUnderMouse.postEvent( type, { x:x, y:y, button:button } );
        else
            xinf.event.EventDispatcher.postGlobalEvent( type, { x:x, y:y, button:button } );
    }

    private function handleMouseMotionEvent( e, k ) :Void {
        mouseX = SDL.MouseMotionEvent_x_get(e);
        mouseY = SDL.MouseMotionEvent_y_get(e);
        if( objectUnderMouse != null )
            objectUnderMouse.postEvent( Event.MOUSE_MOVE, { x:mouseX, y:mouseY } );
        else
            xinf.event.EventDispatcher.postGlobalEvent( Event.MOUSE_MOVE, { x:mouseX, y:mouseY } );
    }
        
    /* ------------------------------------------------------
       OpenGL Helper Functions
       ------------------------------------------------------ */
    
    public function startFrame() : Void {
        GL.PushMatrix();
    	GL.Viewport( 0, 0, Math.floor(width), Math.floor(height) );
        GL.MatrixMode( GL.PROJECTION );
        GL.LoadIdentity();
        GL.MatrixMode( GL.MODELVIEW );
        GL.LoadIdentity();
        

        GL.ClearColor( 1., 1., 1., .0 );
        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
    }

    public function endFrame() : Void {
        GL.PopMatrix();
        SDL.GL_SwapBuffers();
    }

    /* ------------------------------------------------------
       HitTest Functions
       ------------------------------------------------------ */

    public function startPick( x:Float, y:Float ) : Void {
        GL.SelectBuffer( 64, selectBuffer );
        
        GL.GetIntegerv( GL.VIEWPORT, view );
        GL.RenderMode( GL.SELECT );
        GL.InitNames();
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PushMatrix();
            
            GL.LoadIdentity();
            GLU.PickMatrix( x, y, 1.0, 1.0, view );
            GL.MatrixMode( GL.MODELVIEW );
            
            GL.Disable( GL.BLEND );
    }
    
    public function endPick() : Array<Array<Int>> {
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PopMatrix();
        
        var n_hits = GL.RenderMode( GL.RENDER );
        
        // process the GL SelectBuffer into a simple array of arrays of names.
        var stacks = new Array<Array<Int>>();
        if( n_hits > 0 ) {
            var i=0; 
            var j=0;
            while( i<n_hits && j<64 ) {
                var n : Int = CPtr.uint_get( selectBuffer, j);
                var objs = new Array<Int>();
                j+=3;
                for( k in 0...n ) {
                    objs.push( Math.round(CPtr.uint_get( selectBuffer, j )));
                    j++;
                }
                i++;
                stacks.push(objs);
            }
        }
        
        GL.MatrixMode( GL.MODELVIEW );
        GL.Enable( GL.BLEND );
        return stacks;
    }
    
    
    public function getObjectsUnderPoint( x:Float, y:Float ) : Array<Object> {
        
        startPick( x, height-y );
        
        renderSimple();
        var hits:Array<Array<Int>> = endPick();
        
        var a:Array<Object> = new Array<Object>();
        for( hit in hits ) {
            var object:Object = this;
            var group:Group;
            try {
                group = cast(object,Group);
                object = group.getHitChild(hit,x,y);
                a.push(object);
            } catch(e:Dynamic) {
                // dont do anything
                // should only happen if the hitpoint is cropped out
            }
        }

// root has no owner... but.. FIXME       if( a.length == 0 ) a.push( this );
        
        return a;
    }
    
    public function doOverOut() :Void {
        var o = getObjectsUnderPoint( mouseX, mouseY ).pop();
        if( o != objectUnderMouse ) {
            if( objectUnderMouse != null )
                objectUnderMouse.postEvent( Event.MOUSE_OUT, { x:mouseX, y:mouseY } );
//                trace("overOut: old "+objectUnderMouse+", new "+o );
            objectUnderMouse = o;
            if( objectUnderMouse != null )
                objectUnderMouse.postEvent( Event.MOUSE_OVER, { x:mouseX, y:mouseY } );
        }
    }
}
