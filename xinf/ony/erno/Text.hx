/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.TextFormat;
import xinf.event.SimpleEvent;
import xinf.geom.Types;

class Text extends xinf.ony.Text {
	
	var format:TextFormat;
	
	public function new(?traits:Dynamic) :Void {
		super(traits);
	}

	override public function styleChanged( ?attribute:String ) :Void {
		super.styleChanged( attribute );
		format = null;
	}

	function assureFormat() {
		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
			// TODO: weight, style; FIXME: family fallback
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			format.assureGlyphs( text, format.size );
		}
	}

	override public function drawContents( g:Renderer ) :Void {
		super.drawContents(g);
		assureFormat();
		if( text!=null ) {
			var _x =
				switch( textAnchor ) {
					case Start:
						x;
					case Middle:
						x-( format.textSize(text).x/2 );
					case End:
						x-( format.textSize(text).x );
				}
			var _y =
				switch( alignmentBaseline ) {
					case Baseline:
						y-(format.ascender());
					case Middle:
						y-( format.textSize("Xy").y/2. );
					case Hanging:
						y;
				}

			g.text( _x, _y, text, format );
		}
	}

	function alignment() :Float {
		return
			switch( textAnchor ) {
				case Start:  0.;
				case Middle: 0.5;
				case End:    1.0;
			}
	}

	override public function getBoundingBox() : TRectangle {
		if( text==null ) return { l:x, t:y, r:x, b:y };
		assureFormat();
		var b = format.textSize(text);
		var yy = y-format.ascender();
		var xx = x-(b.x*alignment());
		return { l:xx, t:yy, r:xx+b.x, b:yy+b.y };
	}

}
