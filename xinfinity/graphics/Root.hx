package xinfinity.graphics;

import SDL;
import xinf.event.Event;

class Root extends Stage {
    public static var root:Root = new Root(320,240);

    private var quit : Bool;
    public var buttonpress : Bool;
    
    public function new( w:Int, h:Int ) {
        super( w, h );
        
        quit = false;
        
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
            
            processEvents();
            
            startFrame();
            
                Object.cacheChanged();
                _render();
        
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
    
    public function processEvents() {
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
//                    handleMouseMotionEvent( me, k );
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

        var type:String = Event.MOUSE_UP;
        if( k == SDL.MOUSEBUTTONDOWN ) type = Event.MOUSE_DOWN;
        
        trace( "event: "+type );
/*        
        var e:MouseEvent = new MouseEvent( { 
            type: type,
            stageX: x,
            stageY: y
            } ); 

        dispatchToTargets( e, x, y );
        */
    }
    
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
        
        GL.ClearColor( 0, 0, 0.7, 1 );
        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
    }

    public function endFrame() : Void {
        GL.PopMatrix();
        SDL.GL_SwapBuffers();
    }
}
