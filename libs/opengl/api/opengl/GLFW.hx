package opengl;

/**
    GLFW functions. 
    
    <nekobind 
        prefix="glfw"
        module="opengl"
        global="true"
        translator="Capitalize"
        globalFinderPrefix="GLFW_"
        globalFinderCCFlags="-lGL -lGLU -lglfw"
        />
    <nekobind:cHeader>
    #ifdef NEKO_OSX
        #include &lt;OpenGL/gl.h&gt;
        #include &lt;OpenGL/glu.h&gt;
        #include &lt;GLUT/glut.h&gt;
    #else
        #include &lt;GL/gl.h&gt;
        #include &lt;GL/glu.h&gt;
        #include &lt;GL/glfw.h&gt;
    #endif
    </nekobind:cHeader>
**/

extern class GLFW {
	public static var VERSION_MAJOR:Int;
	public static var VERSION_MINOR:Int;
	public static var VERSION_REVISION:Int;
	public static var RELEASE:Int;
	public static var PRESS:Int;
	public static var KEY_UNKNOWN:Int;
	public static var KEY_SPACE:Int;
	public static var KEY_SPECIAL:Int;
	public static var KEY_ESC:Int;
	public static var KEY_F1:Int;
	public static var KEY_F2:Int;
	public static var KEY_F3:Int;
	public static var KEY_F4:Int;
	public static var KEY_F5:Int;
	public static var KEY_F6:Int;
	public static var KEY_F7:Int;
	public static var KEY_F8:Int;
	public static var KEY_F9:Int;
	public static var KEY_F10:Int;
	public static var KEY_F11:Int;
	public static var KEY_F12:Int;
	public static var KEY_F13:Int;
	public static var KEY_F14:Int;
	public static var KEY_F15:Int;
	public static var KEY_F16:Int;
	public static var KEY_F17:Int;
	public static var KEY_F18:Int;
	public static var KEY_F19:Int;
	public static var KEY_F20:Int;
	public static var KEY_F21:Int;
	public static var KEY_F22:Int;
	public static var KEY_F23:Int;
	public static var KEY_F24:Int;
	public static var KEY_F25:Int;
	public static var KEY_UP:Int;
	public static var KEY_DOWN:Int;
	public static var KEY_LEFT:Int;
	public static var KEY_RIGHT:Int;
	public static var KEY_LSHIFT:Int;
	public static var KEY_RSHIFT:Int;
	public static var KEY_LCTRL:Int;
	public static var KEY_RCTRL:Int;
	public static var KEY_LALT:Int;
	public static var KEY_RALT:Int;
	public static var KEY_TAB:Int;
	public static var KEY_ENTER:Int;
	public static var KEY_BACKSPACE:Int;
	public static var KEY_INSERT:Int;
	public static var KEY_DEL:Int;
	public static var KEY_PAGEUP:Int;
	public static var KEY_PAGEDOWN:Int;
	public static var KEY_HOME:Int;
	public static var KEY_END:Int;
	public static var KEY_KP_0:Int;
	public static var KEY_KP_1:Int;
	public static var KEY_KP_2:Int;
	public static var KEY_KP_3:Int;
	public static var KEY_KP_4:Int;
	public static var KEY_KP_5:Int;
	public static var KEY_KP_6:Int;
	public static var KEY_KP_7:Int;
	public static var KEY_KP_8:Int;
	public static var KEY_KP_9:Int;
	public static var KEY_KP_DIVIDE:Int;
	public static var KEY_KP_MULTIPLY:Int;
	public static var KEY_KP_SUBTRACT:Int;
	public static var KEY_KP_ADD:Int;
	public static var KEY_KP_DECIMAL:Int;
	public static var KEY_KP_EQUAL:Int;
	public static var KEY_KP_ENTER:Int;
	public static var KEY_LAST:Int;
	public static var MOUSE_BUTTON_1:Int;
	public static var MOUSE_BUTTON_2:Int;
	public static var MOUSE_BUTTON_3:Int;
	public static var MOUSE_BUTTON_4:Int;
	public static var MOUSE_BUTTON_5:Int;
	public static var MOUSE_BUTTON_6:Int;
	public static var MOUSE_BUTTON_7:Int;
	public static var MOUSE_BUTTON_8:Int;
	public static var MOUSE_BUTTON_LAST:Int;
	public static var MOUSE_BUTTON_LEFT:Int;
	public static var MOUSE_BUTTON_RIGHT:Int;
	public static var MOUSE_BUTTON_MIDDLE:Int;
	public static var JOYSTICK_1:Int;
	public static var JOYSTICK_2:Int;
	public static var JOYSTICK_3:Int;
	public static var JOYSTICK_4:Int;
	public static var JOYSTICK_5:Int;
	public static var JOYSTICK_6:Int;
	public static var JOYSTICK_7:Int;
	public static var JOYSTICK_8:Int;
	public static var JOYSTICK_9:Int;
	public static var JOYSTICK_10:Int;
	public static var JOYSTICK_11:Int;
	public static var JOYSTICK_12:Int;
	public static var JOYSTICK_13:Int;
	public static var JOYSTICK_14:Int;
	public static var JOYSTICK_15:Int;
	public static var JOYSTICK_16:Int;
	public static var JOYSTICK_LAST:Int;
	public static var WINDOW:Int;
	public static var FULLSCREEN:Int;
	public static var OPENED:Int;
	public static var ACTIVE:Int;
	public static var ICONIFIED:Int;
	public static var ACCELERATED:Int;
	public static var RED_BITS:Int;
	public static var GREEN_BITS:Int;
	public static var BLUE_BITS:Int;
	public static var ALPHA_BITS:Int;
	public static var DEPTH_BITS:Int;
	public static var STENCIL_BITS:Int;
	public static var REFRESH_RATE:Int;
	public static var ACCUM_RED_BITS:Int;
	public static var ACCUM_GREEN_BITS:Int;
	public static var ACCUM_BLUE_BITS:Int;
	public static var ACCUM_ALPHA_BITS:Int;
	public static var AUX_BUFFERS:Int;
	public static var STEREO:Int;
	public static var MOUSE_CURSOR:Int;
	public static var STICKY_KEYS:Int;
	public static var STICKY_MOUSE_BUTTONS:Int;
	public static var SYSTEM_KEYS:Int;
	public static var KEY_REPEAT:Int;
	public static var AUTO_POLL_EVENTS:Int;
	public static var WAIT:Int;
	public static var NOWAIT:Int;
	public static var PRESENT:Int;
	public static var AXES:Int;
	public static var BUTTONS:Int;
	public static var NO_RESCALE_BIT:Int;
	public static var ORIGIN_UL_BIT:Int;
	public static var BUILD_MIPMAPS_BIT:Int;
	public static var ALPHA_MAP_BIT:Int;
	public static var INFINITY:Int;

//    public static function init() :Bool; // done in additions::glfw_setup
    public static function terminate() :Void;
//    public static function getVersion() :Void;

    public static function openWindow( width:Int, height:Int, redBits:Int, greenBits:Int, blueBits:Int, alphaBits:Int, depthBits:Int, stencilBits:Int, mode:Int ) :Bool;
	public static function openWindowHint( target:Int, hint:Int ) :Void;
	public static function closeWindow() :Void;
	public static function setWindowTitle( title:String ) :Void;
//	public static function getWindowSize() :Void;
	public static function setWindowSize( width:Int, height:Int ) :Void;
	public static function setWindowPos( x:Int, y:Int ) :Void;
	public static function iconifyWindow() :Void;
	public static function restoreWindow() :Void;
	public static function swapBuffers() :Void;
	public static function swapInterval( interval:Int ) :Void;
	public static function getWindowParam( param:Int ) :Int;

	// Int->Int->Void
	public static function setWindowSizeFunction( f:Dynamic ) :Void;
	// Void->Int
	public static function setWindowCloseFunction( f:Dynamic ) :Void;
	// Void->Void
	public static function setWindowRefreshFunction( f:Dynamic ) :Void;
	
	//public static function getVideoModes() :Void;
	//public static function getDesktopMode() :Void;
	
	public static function pollEvents() :Void;
	public static function waitEvents() :Void;
	
	public static function getKey( key:Int ) :Int;
	public static function getMouseButton( button:Int ) :Int;
	//public static function getMousePos() :Void;
	public static function setMousePos( x:Int, y:Int ) :Void;
	public static function getMouseWheel() :Int;
	public static function setMouseWheel( pos:Int ) :Void;
	
	// Int->Int->Void
	public static function setKeyFunction( f:Dynamic ) :Void;
	// Int->Int->Void
	public static function setCharFunction( f:Dynamic ) :Void;
	// Int->Int->Void
	public static function setMouseButtonFunction( f:Dynamic ) :Void;
	// Int->Int->Void
	public static function setMousePosFunction( f:Dynamic ) :Void;
	// Int->Void
	public static function setMouseWheelFunction( f:Dynamic ) :Void;
	
	//public static function () :Void;

    public static function __init__() : Void {
        DLLLoader.addLibToPath("opengl");
        untyped {
            var loader = untyped __dollar__loader;
            GLFW = loader.loadmodule("opengl".__s,loader).GLFW__impl;
        }
    }
}
