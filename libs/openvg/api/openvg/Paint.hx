/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package openvg;

/**
	<nekobind 
		translator="Capitalize"
		prefix="vg"
		nekoAbstract="__h"
		cStruct="VGPaint"
		dtor="destroyPaint"
		dtorLock="true"
		module="openvg"
		friends="openvg.Handle:VGHandle>__h"
		/>
	<nekobind:cHeader>
		#include &lt;vg/openvg.h&gt;
		#include "helper.h"
	</nekobind:cHeader>
**/

extern class Paint {
	private function new() :Void;

	/** <nekobind ctor="true" suffix="Paint"/> **/
	public static function create() :Paint;

	/** <nekobind suffix="Paint"/> **/
	public function set( paintModes:Int ) :Void;
	// NYI public static function getPaint( paintModes:Int ) :Int;
	// NYI public function setColor( rgba:Int ) :Void; // Float? "Color"?
	// NYI public function getColor() :Int;			   // Float? "Color"?
	// NYI public function paintPattern( pattern:Image ) :Void;

	public function setParameterf( type:Int, value:Float ) :Void;
	public function setParameteri( type:Int, value:Int ) :Void;
	/** <nekobind><cptr name="value" type="float" min-size="count"/></nekobind> **/
	public function setParameterfv( type:Float, count:Int, value:String ) :Void;
	/** <nekobind><cptr name="value" type="int" min-size="count"/></nekobind> **/
	public function setParameteriv( type:Float, count:Int, value:String ) :Void;

	public function getParameterf( type:Int ) :Float;
	public function getParameteri( type:Int ) :Int;
	public function getParameterVectorSize( type:Int ) :Int;
	/** <nekobind><cptr name="values" type="float" min-size="count"/></nekobind> **/
	public function getParameterfv( type:Int, count:Int, values:String ) :Void;
	/** <nekobind><cptr name="values" type="int" min-size="count"/></nekobind> **/
	public function getParameteriv( type:Int, count:Int, values:String ) :Void;

	public static function __init__() : Void {
		DLLLoader.addLibToPath("openvg");
		untyped {
			var loader = untyped __dollar__loader;
			Paint = loader.loadmodule("openvg".__s,loader).Paint__impl;
		}
	}
}
