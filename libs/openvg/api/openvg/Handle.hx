/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package openvg;

/**
	<nekobind 
		translator="Capitalize"
		prefix="vg"
		nekoAbstract="__h"
		cStruct="VGHandle"
		module="openvg"
		/>
	<nekobind:cHeader>
		#include &lt;vg/openvg.h&gt;
	</nekobind:cHeader>
**/

extern class Handle {
	public function new() :Void;

	/** <nekobind ctor="true"/> **/
	public static function createPaint() :Handle;

	public static function __init__() : Void {
		DLLLoader.addLibToPath("openvg");
		untyped {
			var loader = untyped __dollar__loader;
			Handle = loader.loadmodule("openvg".__s,loader).Handle__impl;
		}
	}
}
