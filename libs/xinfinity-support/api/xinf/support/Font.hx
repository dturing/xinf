/*
*/

package xinf.support;

typedef FTIterateCallbacks = {
	startContour : Int->Int->Void,
	endContour : Void->Void,
	lineTo : Int->Int->Void,
	curveTo : Int->Int->Int->Int->Void,
	endGlyph : Int->Int->Void
}

class Font {
    private static function __init__() : Void {
        DLLLoader.addLibToPath("xinfinity-support");
        _load = neko.Lib.load("xinfinity-support","ftLoadFont",3);
        _iterateGlyphs = neko.Lib.load("xinfinity-support","ftIterateGlyphs",2);
    }

	private var __f:Void;
	
	public function new( filename:String, ?width:Int, ?height:Int ) {
		if( width==null ) width=72;
		if( height==null ) height=72;
		__f = _load( untyped filename.__s, width, height );
	}

	public function iterateAllGlyphs( callbackObject:FTIterateCallbacks ) :Void {
		_iterateGlyphs( __f, callbackObject );
	}

	private static var _load;
	private static var _iterateGlyphs;
}
