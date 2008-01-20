package openvg;

/**
    Global OpenVG functions. 
    Make sure you create (and makeCurrent) a Display before using any of these.
    
    <nekobind 
        prefix="vgu"
        module="openvg"
        global="true"
        translator="Capitalize"
        globalFinderPrefix="VGU_"
        globalFinderCCFlags="-lOpenVG -lGL -lGLU"
        />
    <nekobind:cHeader>
        #include &lt;vg/openvg.h&gt;
        #include &lt;vg/vgu.h&gt;
    </nekobind:cHeader>
**/

extern class VGU {

	public static var NO_ERROR:Int;
	public static var BAD_HANDLE_ERROR:Int;
  	public static var ILLEGAL_ARGUMENT_ERROR:Int;
  	public static var OUT_OF_MEMORY_ERROR:Int;
  	public static var PATH_CAPABILITY_ERROR:Int;
  	public static var BAD_WARP_ERROR:Int;
	
	public static var ARC_OPEN:Int;
	public static var ARC_CHORD:Int;
	public static var ARC_PIE:Int;


	public static function line( path:Int, x0:Float, y0:Float, x1:Float, y1:Float ) :Int;
	/** <nekobind><cptr name="points" type="float" min-size="val_int(n_count)"/></nekobind> **/
	public static function polygon( path:Int, points:String, count:Int, closed:Bool ) :Int;
	public static function rect( path:Int, x:Float, y:Float, width:Float, height:Float ) :Int;
	public static function roundRect( path:Int, x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float ) :Int;
	public static function ellipse( path:Int, cx:Float, cy:Float, width:Float, height:Float ) :Int;
	public static function arc( path:Int, x:Float, y:Float, width:Float, height:Float, startAngle:Float, angleExtent:Float, type:Int ) :Int;


    public static function __init__() : Void {
        DLLLoader.addLibToPath("openvg");
        untyped {
            var loader = untyped __dollar__loader;
            VGU = loader.loadmodule("openvg".__s,loader).VGU__impl;
        }
    }
}
