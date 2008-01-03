/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity.font;

class XTextFormat extends xinf.erno.TextFormat {

    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
    }

    override public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
		return font.textSize( text, size );
    }

    override public function load() :Void {
        super.load();
        try {
            font = Font.getFont( family ); // FIXME: bold, italic?
        } catch(e:Dynamic) {
            font = Font.getFont("_sans");
        }
    }
	
	override public function ascender() :Float {
		assureLoaded();
		return font.ascender*size;
	}

	override public function assureGlyphs( text:String, size:Float ) :Void {
		if( text==null ) return;
		assureLoaded();
		for( i in 0...text.length ) {
	//		trace("assure glyph "+text.charCodeAt(i) );
			font.getGlyph( text.charCodeAt(i), size );
		}
	}

}
