package openvg;

/**
    <nekobind 
        translator="Capitalize"
        prefix="vg"
        nekoAbstract="__h"
        cStruct="VGPath"
        dtor="destroyPath"
        module="openvg"
        />
    <nekobind:cHeader>
        #include &lt;vg/openvg.h&gt;
    </nekobind:cHeader>
**/

extern class Path {
    public function new( format:Int, datatype:Int, scale:Float, bias:Float, segmentCapacityHint:Int, coordCapacityHint:Int, capabilities:Int) :Void;

	/** <nekobind ctor="true"/> **/
	public static function createPath( format:Int, datatype:Int, scale:Float, bias:Float, segmentCapacityHint:Int, coordCapacityHint:Int, capabilities:Int ) :Path;
		
    public static function __init__() : Void {
        untyped {
            var loader = untyped __dollar__loader;
            Path = loader.loadmodule("openvg".__s,loader).Path__impl;
        }
    }
}
