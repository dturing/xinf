/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.TextFormat;
import xinf.event.SimpleEvent;

class Text extends xinf.ony.Text {
    
    var format:TextFormat;
	
	public function new(?traits:Dynamic) :Void {
		super(traits);
	}

    override public function styleChanged( ?attribute:String ) :Void {
        super.styleChanged( attribute );
		format = null;
    }

	override public function draw( g:Renderer ) :Void {
		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
			// TODO: weight, style; FIXME: family fallback
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			format.assureGlyphs( text, format.size );
		}
		
		super.draw(g);
	}

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( text!=null ) {
			switch( textAnchor ) {
				case Start:
					g.text( x,
						y-(format.ascender()),text,format);
				case Middle:
					g.text( x-( format.textSize(text).x/2 ),
						y-(format.ascender()),text,format);
				case End:
					g.text( x-( format.textSize(text).x ),
						y-(format.ascender()),text,format);
			}
        }
    }
    
}
