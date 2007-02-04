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
        _renderGlyph = neko.Lib.load("xinfinity-support","ftRenderGlyph",2);
        _listFonts = neko.Lib.load("xinfinity-support","fcListFonts",1);
        _findFont = neko.Lib.load("xinfinity-support","fcFindFont",4);
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

	public function renderGlyph( index:Int ) :{ width:Int, height:Int, bitmap:Dynamic, x:Int, y:Int } {
		return _renderGlyph( __f, index );
	}

	public static function listFonts( callbackFunction:String->String->Int->Int->Void ) :Void {
		_listFonts( callbackFunction );
	}
    
    public static function findFont( family:String, weight:Int, slant:Int, size:Float ) :String {
        return _findFont( untyped family.__s, weight, slant, size );
	}

	private static var _load;
	private static var _iterateGlyphs;
	private static var _renderGlyph;
	private static var _listFonts;
	private static var _findFont;
}
