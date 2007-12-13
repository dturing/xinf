package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;
import xinf.event.SimpleEvent;

class Text extends xinf.ony.base.Text {
    
    var format:TextFormat;
	
	public function new(?traits:Dynamic) :Void {
		super(traits);
	}

    override public function styleChanged() :Void {
        super.styleChanged();
        
	//	format=null;
        // TODO: weight
    }
    
    override public function drawContents( g:Renderer ) :Void {
		if( format==null ) {
			var family = fontFamily;
			var size = fontSize;
			format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
			//trace("text format: "+format+", fill: "+fill );
		}
		
        super.drawContents(g);
        if( text!=null ) {
			g.text(x,y-format.size,text,format);
        }
    }
    
}
