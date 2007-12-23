/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.TextFormat;
import xinf.event.SimpleEvent;

class Text extends xinf.ony.base.Text {
    
    var format:TextFormat;
	
	public function new(?traits:Dynamic) :Void {
		super(traits);
	}

    override public function styleChanged() :Void {
        super.styleChanged();
        
		if( text==null ) return;
		
		var family = fontFamily;
		var size = fontSize;
        // TODO: weight
		
		format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
		//trace("text format: "+format+", fill: "+fill );
		format.assureGlyphs( text, size );
    }
    
    override public function drawContents( g:Renderer ) :Void {
		
        super.drawContents(g);
        if( text!=null ) {
			switch( textAnchor ) {
				case Start:
					g.text(x,y-format.size,text,format);
				case Middle:
					g.text( x-( format.textSize(text).x/2 ),
						y-format.size,text,format);
				case End:
					g.text( x-( format.textSize(text).x ),
						y-format.size,text,format);
			}
        }
    }
    
}
