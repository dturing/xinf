/*
*/

package freetype;


typedef FTIterateCallbacks = {
	startContour : Int->Int->Void,
	endContour : Void->Void,
	lineTo : Int->Int->Void,
	curveTo : Int->Int->Int->Int->Void,
	endGlyph : Int->Int->Void
}

class Font {
	private var __f:Void;
	
	public function new( filename:String, ?width:Int, ?height:Int ) {
		if( width==null ) width=72;
		if( height==null ) height=72;
		__f = _load( untyped filename.__s, width, height );
	}

	public function iterateAllGlyphs( callbackObject:FTIterateCallbacks ) :Void {
		_IterateGlyphs( __f, callbackObject );
	}

	private static var _load = neko.Lib.load("freetype","ftLoadFont",3);
	private static var _IterateGlyphs = neko.Lib.load("freetype","ftIterateGlyphs",2);
}
