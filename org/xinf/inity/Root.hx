package org.xinf.inity;

import SDL;
import org.xinf.event.Event;

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
        resize(w,h);
    }

    public function resize( w:Int, h:Int ) : Void {
        super.resize(w,h);
        if( SDL.SetVideoMode( Math.floor(width), Math.floor(height), 32, SDL.OPENGL | SDL.RESIZABLE | SDL.GL_DOUBLEBUFFER ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }
    }
    
    public function run() : Bool {
        while( !quit ) {
        
            org.xinf.event.EventDispatcher.global.dispatchEvent( new Event( Event.ENTER_FRAME, this.owner ) );
            
            processEvents();

            Object.cacheChanged();
            doOverOut();
            Object.cacheChanged();
            
            startFrame();
                render();
            endFrame();
        
            // check for OpenGL errors
            var e:Int = GL.GetError();
            if( e > 0 ) {
                throw( "OpenGL error "+GLU.ErrorString(e) );
            }
            
            // FIXME: proper timing, neko idle func?
            neko.Sys.sleep(0.03);
        }
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
                //    trace("active event");
                    // todo: mouseout on any overe'd item
                case SDL.VIDEOEXPOSE:
               //     trace("expose event");
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
//        trace("Key "+name+" "+type );
        org.xinf.event.EventDispatcher.global.dispatchEvent( 
                org.xinf.event.Event.KeyboardEvent( type, null, str )
            );
    }

    private function handleMouseEvent( e, k ) :Void {
        buttonpress = k == SDL.MOUSEBUTTONDOWN;
        var x = SDL.MouseButtonEvent_x_get(e);
        var y = SDL.MouseButtonEvent_y_get(e);

        var type:String = Event.MOUSE_UP;
        if( k == SDL.MOUSEBUTTONDOWN ) type = Event.MOUSE_DOWN;
        
        if( objectUnderMouse != null )
            objectUnderMouse.dispatchEvent( new Event( type, objectUnderMouse.owner ) );
    }

    private function handleMouseMotionEvent( e, k ) :Void {
        mouseX = SDL.MouseMotionEvent_x_get(e);
        mouseY = SDL.MouseMotionEvent_y_get(e);
        if( objectUnderMouse != null )
            objectUnderMouse.dispatchEvent( new Event( Event.MOUSE_MOVE, objectUnderMouse.owner ) );
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
        
        GL.PixelStorei( GL.UNPACK_ALIGNMENT, 1 );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );

        GL.Enable( GL.BLEND );
        GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
        
        GL.ShadeModel( GL.FLAT );
        /*
        var c = style.backgroundColor;
//        trace("BG: "+style.background );
        if( c != null ) // FIXME
            GL.ClearColor( c.r/0xff, c.g/0xff, c.b/0xff, 1 );
            */
        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
    }

    public function endFrame() : Void {
        GL.PopMatrix();
        SDL.GL_SwapBuffers();
    }

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
                    objs.push( CPtr.uint_get( selectBuffer, j ));
                    j++;
                }
                i++;
                stacks.push(objs);
            }
        }
        
        GL.MatrixMode( GL.MODELVIEW );
        
        return stacks;
    }
    
    /* ------------------------------------------------------
       HitTest Functions
       ------------------------------------------------------ */
    
    public function getObjectsUnderPoint( x:Float, y:Float ) : Array<Object> {
        
        startPick( x, y );
        
        // this takes loong! (displaylists in select mode not accelerated??)
        // alternatively, do some "low-res" (bbox) preselection?
        renderSimple();
        var hits:Array<Array<Int>> = endPick();
        
        var a:Array<Object> = new Array<Object>();
        for( hit in hits ) {
            var object:Object = this;
            var group:Group;
            for( id in hit ) {
                group = cast(object,Group); // will throw if not a Group
                object = group.getChildAt(id);
                if( object == null ) throw("hit child not found");
            }
            a.push(object);
        }
        
// root has no owner... but.. FIXME       if( a.length == 0 ) a.push( this );
        
        return a;
    }
    
    public function doOverOut() :Void {
        var o = getObjectsUnderPoint( mouseX, height-mouseY ).pop();
        if( o != objectUnderMouse ) {
            if( objectUnderMouse != null )
                objectUnderMouse.dispatchEvent( new Event( Event.MOUSE_OUT, objectUnderMouse.owner ) );
            objectUnderMouse = o;
            if( objectUnderMouse != null )
                objectUnderMouse.dispatchEvent( new Event( Event.MOUSE_OVER, objectUnderMouse.owner ) );
        }
    }
}
