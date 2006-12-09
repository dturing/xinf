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

	/** <nekobind><cptr name="argv" null-allowed="true" type="char*"/>
				<cptr name="argn" null-allowed="true" type="int"/></nekobind> **/
	public static function init(argn:Dynamic,argv:Dynamic) :Void;

	public static function initSimple() :Void;
	
	public static function setDisplay( func:Dynamic ) :Void; // Void->Void
	public static function setTimer( seconds:Int, func:Dynamic, value:Int ) :Void; // Int->Void
	public static function setReshape( func:Dynamic ) :Void; // Int->Int->Void

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


	public static function solidTeapot( size:Float ) :Void;

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