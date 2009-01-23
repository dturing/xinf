/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package opengl;

/**
	Global OpenGL functions. 
	Make sure you create (and makeCurrent) a Display before using any of these.
	
	<nekobind 
		translator="Capitalize"
		prefix="texture"
		nekoAbstract="__t"
		cStruct="GLuint*"
		dtor="delete"
		module="opengl"
		/>
	<nekobind:cHeader>
	#ifdef NEKO_OSX
		#include &lt;OpenGL/gl.h&gt;
	#else
		#include &lt;GL/gl.h&gt;
		#include "texture.h"
	#endif
	</nekobind:cHeader>
**/

extern class Texture {
	private function new() :Void;

	/** <nekobind ctor="true"/> **/
	public static function create() :Texture;
	
	public function bind() :Void;
	
	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*4)"/></nekobind> **/
	public static function subImageRGBA( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*4)"/></nekobind> **/
	public static function subImageBGRA( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*3)"/></nekobind> **/
	public static function subImageRGB( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height*3)"/></nekobind> **/
	public static function subImageBGR( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function subImageGRAY( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function subImageALPHA( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;

	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function imageClearFT( width:Int, height:Int ) :Void;
	
	/** <nekobind><cptr name="pixels" type="unsigned char" min-size="(width*height)"/></nekobind> **/
	public static function subImageFT( x:Int, y:Int, width:Int, height:Int, pixels:Dynamic ) :Void;


	public static function __init__() : Void {
		DLLLoader.addLibToPath("opengl");
		untyped {
			var loader = untyped __dollar__loader;
			Texture = loader.loadmodule("opengl".__s,loader).Texture__impl;
		}
	}
}

