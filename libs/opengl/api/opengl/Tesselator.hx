
package opengl;

/**
	A propped-up GLU Tesselator.
	
	<nekobind 
		translator="Capitalize"
		prefix="gluTess"
		nekoAbstract="__tess"
		cStruct="GLUtesselator"
		dtor="close"
		module="opengl"
		/>
	<nekobind:cHeader>
		#include "tesselation.h"
	</nekobind:cHeader>
**/
extern class Tesselator {
	private function new() :Void;

	/** <nekobind ctor="true"/> **/
	public static function create() :Tesselator;
	
	public function beginContour():Void;
	/** <nekobind><cptr name="data" type="void" null-allowed="true"/></nekobind> **/
	public function beginPolygon( data:Void ):Void;
	public function endContour():Void;
	public function endPolygon():Void;
	public function normal( valueX:Float, valueY:Float, valueZ:Float ):Void;
	public function property( which:Int, data:Float ):Void;
	

	/** <nekobind><cptr name="v" type="double" min-size="3"/></nekobind> **/
	public function vertexSimple( v:Dynamic ):Void;
	/** <nekobind><cptr name="v" type="double" min-size="(offset+3)"/></nekobind> **/
	public function vertexOffset( offset:Int, v:Dynamic ):Void;

    public static function __init__() : Void {
        untyped {
        	var loader = untyped __dollar__loader;
            Tesselator = loader.loadmodule("opengl".__s,loader).Tesselator__impl;
        }
    }
}
