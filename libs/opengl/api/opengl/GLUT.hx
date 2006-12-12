package opengl;

/**
	GLUT functions. 
	
	<nekobind 
		prefix="glut"
		module="opengl"
		global="true"
		translator="Capitalize"
		globalFinderPrefix="GLUT_"
		globalFinderCCFlags="-lGL -lGLU -lglut"
		/>
	<nekobind:cHeader>
	#ifdef NEKO_OSX
		#include &lt;OpenGL/gl.h&gt;
		#include &lt;OpenGL/glu.h&gt;
		#include &lt;GLUT/glut.h&gt;
	#else
		#include &lt;GL/gl.h&gt;
		#include &lt;GL/glu.h&gt;
		#include &lt;GL/glut.h&gt;
	#endif
	</nekobind:cHeader>
**/

extern class GLUT {
	public static var DOUBLE:Int;
	public static var RGB:Int;
	public static var DEPTH:Int;

	public static var KEY_UP:Int;
	public static var KEY_DOWN:Int;
	public static var KEY_LEFT:Int;
	public static var KEY_RIGHT:Int;
	public static var KEY_PAGE_UP:Int;
	public static var KEY_PAGE_DOWN:Int;
	public static var KEY_HOME:Int;
	public static var KEY_END:Int;
	public static var KEY_INSERT:Int;
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

	/** <nekobind><cptr name="argv" null-allowed="true" type="char*"/>
				<cptr name="argn" null-allowed="true" type="int"/></nekobind> **/
	public static function init(argn:Dynamic,argv:Dynamic) :Void;

	public static function initSimple() :Void;
	
	public static function setDisplayFunc( func:Dynamic ) :Void; // Void->Void
	public static function setReshapeFunc( func:Dynamic ) :Void; // Int->Int->Void
	public static function setKeyboardFunc( func:Dynamic ) :Void; // String->Int->Int->Void
	public static function setSpecialFunc( func:Dynamic ) :Void; // Int->Int->Int->Void
	public static function setMouseFunc( func:Dynamic ) :Void; // Int->Int->Int->Int->Void
	public static function setMotionFunc( func:Dynamic ) :Void; // Int->Int->Void
	public static function setTimerFunc( seconds:Int, func:Dynamic, value:Int ) :Void; // Int->Void
	public static function setExitFunc( func:Dynamic ) :Void; // Void->Void, is really GNU atexit.

	public static function initDisplayMode( mode:Int ) :Void;
	
	public static function initWindowSize( width:Int, height:Int ) :Void;
	public static function createWindow( name:String ) :Int;
	public static function showWindow() :Void;
	
	public static function setWindow( window:Int ) :Void;
	public static function positionWindow( x:Int, y:Int ) :Void;
	public static function reshapeWindow( width:Int, height:Int ) :Void;
	public static function fullScreen() :Void;
	public static function hideWindow() :Void;
	public static function iconifyWindow() :Void;
	public static function setWindowTitle( title:String ) :Void;
	public static function setIconTitle( title:String ) :Void;

	public static function postRedisplay() :Void;
	public static function swapBuffers() :Void;

	public static function mainLoop() :Void;


	public static function wireCube( size:Float ) :Void;
	public static function solidCube( size:Float ) :Void;
	public static function wireTeapot( size:Float ) :Void;
	public static function solidTeapot( size:Float ) :Void;
	public static function wireOctahedron() :Void;
	public static function solidOctahedron() :Void;
	
	public static function __init__() : Void {
        untyped {
        	var loader = untyped __dollar__loader;
            GLUT = loader.loadmodule("opengl".__s,loader).GLUT__impl;
        }
		initSimple();
    }
}


typedef GLUTCallbacks = {
	display: Void->Void,
	timer: Void->Void,
	reshape: Int->Int->Void
}