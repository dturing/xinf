package openvg;

/**
    <nekobind 
        translator="Capitalize"
        prefix="vg"
        nekoAbstract="__h"
        cStruct="VGPaint"
        dtor="destroyPaint"
        module="openvg"
        friends="openvg.Handle:VGHandle>__h"
        />
    <nekobind:cHeader>
        #include &lt;vg/openvg.h&gt;
    </nekobind:cHeader>
**/

extern class Paint {
    public function new() :Void;

	/** <nekobind ctor="true"/> **/
	public static function createPaint() :Paint;

	public function setParameterf( type:Int, value:Float ) :Void;
	public function setParameteri( type:Int, value:Int ) :Void;
	/** <nekobind><cptr name="value" type="float" min-size="count"/></nekobind> **/
	public function setParameterfv( type:Float, count:Int, value:String ) :Void;
	/** <nekobind><cptr name="value" type="int" min-size="count"/></nekobind> **/
	public function setParameteriv( type:Float, count:Int, value:String ) :Void;

    public static function __init__() : Void {
        untyped {
            var loader = untyped __dollar__loader;
            Paint = loader.loadmodule("openvg".__s,loader).Paint__impl;
        }
    }
}
