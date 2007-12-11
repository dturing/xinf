package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;
import xinf.event.SimpleEvent;

class Text extends xinf.ony.base.Text {
    
    var format:TextFormat;
	
	public function new() :Void {
		super();
		format = TextFormat.getDefault();
	}

    override public function styleChanged() :Void {
        super.styleChanged();
        
        var family = style.fontFamily;
        var size = style.fontSize;
        format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
        // TODO: weight
    }
    
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( text!=null ) {
			g.text(x,y-format.size,text,format);
        }
    }
    
}
