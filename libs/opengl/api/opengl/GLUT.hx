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
	public static function setupHandlers( callbacks:Dynamic ) :Void;

	public static function initDisplayMode( mode:Int ) :Void;
	public static function initWindowSize( width:Int, height:Int ) :Void;
	public static function createWindow( name:String ) :Void;
	public static function showWindow() :Void;
	public static function postRedisplay() :Void;
	public static function swapBuffers() :Void;

	public static function mainLoop() :Void;

	public static function __init__() : Void {
        untyped {
        	var loader = untyped __dollar__loader;
            GLUT = loader.loadmodule("opengl".__s,loader).GLUT__impl;
        }
		initSimple();
    }
}
