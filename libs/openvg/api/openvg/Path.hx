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
	
    private function new( format:Int, datatype:Int, scale:Float, bias:Float, segmentCapacityHint:Int, coordCapacityHint:Int, capabilities:Int) :Void;

	/** <nekobind ctor="true" suffix="Path"/> **/
	public static function create( format:Int, datatype:Int, scale:Float, bias:Float, segmentCapacityHint:Int, coordCapacityHint:Int, capabilities:Int ) :Path;

	/** <nekobind suffix="Path"/> **/
	public function draw( paintModes:Int ):Void;
	/** <nekobind suffix="Path"/> **/
	public function clear( capabilities:Int ) :Void;
	public function removePathCapabilities( capabilities:Int ) :Void;
	public function getPathCapabilities() :Int;
	public function appendPath( src:Path ) :Void;
	
	/** <nekobind functionName="appendPathData">
		<cptr name="pathSegments" type="unsigned char" min-size="numSegments"/>
		<cptr name="values" type="float" min-size="0"/></nekobind> **/
	public function appendData( numSegments:Int, pathSegments:String, pathData:String ) :Void;
	/** <nekobind functionName="modifyPathCoords">
		<cptr name="values" type="float" min-size="0"/></nekobind> **/
	public function modifyCoords( startIndex:Int, numSegments:Int, pathData:String ) :Void;
	/** <nekobind suffix="Path"/> **/
	public function transform( srcpath:Path ) :Void;
	/** <nekobind suffix="Path"/> **/
	public function interpolate( startpath:Path, endpath:Path, amount:Float ) :Bool;
	// NYI public static function pathLength( path:Path, startSegment:Int, numSegments:Int ) :Float;
	/** <nekobind>
		<cptr name="x" type="float" min-size="1"/>
		<cptr name="y" type="float" min-size="1"/>
		<cptr name="tangentX" type="float" min-size="1"/>
		<cptr name="tangentY" type="float" min-size="1"/>
		</nekobind> **/
	// NYI public function pointAlongPath( startSegment:Int, numSegments:Int,
	//								distance:Float, x:String, y:String, tangentX:String, tangentY:String ) :Void;
	/** <nekobind>
		<cptr name="minX" type="float" min-size="1"/>
		<cptr name="minY" type="float" min-size="1"/>
		<cptr name="width" type="float" min-size="1"/>
		<cptr name="height" type="float" min-size="1"/>
		</nekobind> **/
	public function pathBounds( minX:String, minY:String, width:String, height:String ):Void;
	/** <nekobind>
		<cptr name="minX" type="float" min-size="1"/>
		<cptr name="minY" type="float" min-size="1"/>
		<cptr name="width" type="float" min-size="1"/>
		<cptr name="height" type="float" min-size="1"/>
		</nekobind> **/
	public function pathTransformedBounds( minX:String, minY:String, width:String, height:String ):Void;

    public static function __init__() : Void {
        untyped {
            var loader = untyped __dollar__loader;
            Path = loader.loadmodule("openvg".__s,loader).Path__impl;
        }
    }
}
