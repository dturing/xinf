/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

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
		_renderGlyph = neko.Lib.load("xinfinity-support","ftRenderGlyph",4);
		_listFonts = neko.Lib.load("xinfinity-support","fcListFonts",1);
		_findFont = neko.Lib.load("xinfinity-support","fcFindFont",4);
	}

	private var __f:Void;

	public var family_name(default,null):String;
	public var style_name(default,null):String;
	public var ascender(default,null):Float;
	public var descender(default,null):Float;
	public var height(default,null):Float;
	public var underline_thickness(default,null):Float;
	public var underline_position(default,null):Float;
	public var units_per_EM(default,null):Float;

	public function new( data:String, ?width:Int, ?height:Int ) {
		if( width==null ) width=72;
		if( height==null ) height=width;
		var _f = _load( untyped data.__s, width, height );
		
		__f = _f;
		
		for( field in [ 
			"family_name", "style_name", "file_name"
			] ) {
			var h = untyped __dollar__hash(field.__s);
			untyped __dollar__objset( this, h, untyped __dollar__objget( _f, h ) );
		}

		for( field in [ 
			"underline_thickness", "underline_position", 
			"height", "ascender", "descender", "units_per_EM"
			] ) {
			var h = untyped __dollar__hash(field.__s);
			untyped __dollar__objset( this, h, untyped __dollar__objget( _f, h ) / _f.units_per_EM );
		}
	}

	public function iterateAllGlyphs( callbackObject:FTIterateCallbacks ) :Void {
		_iterateGlyphs( __f, callbackObject );
	}

	public function renderGlyph( index:Int, size:Float, hint:Bool ) :{ width:Int, height:Int, bitmap:Dynamic, x:Int, y:Int, advance:Float } {
		return _renderGlyph( __f, index, size, hint );
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
