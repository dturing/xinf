package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

class StyleElement extends xinf.ony.Object {
    
    public var style :Style;
    
    public function new() :Void {
        super();
        style = StyleSheet.newDefaultStyle();
    }
    

    public function applyStyle( s:Style ) {
        style = s;
        
        // resize to same inner size, in case padding has changed
// FIXME        if( innerSize!=null ) resizeInner(innerSize.x,innerSize.y);
        
        scheduleRedraw();
    }
    
    public function setStyleStroke( g:Renderer, width:Float, colorProperty:String, ?colorFallback:Color ) :Void {
        var c:Color = style.get(colorProperty,colorFallback);
        if( c!=null ) 
            g.setStroke( c.r, c.g, c.b, c.a, width );
        else
            g.setStroke( 0,0,0,0,0 );
    }

    public function setStyleFill( g:Renderer, colorProperty:String, ?colorFallback:Color ) :Void {
        var c:Color = style.get(colorProperty,colorFallback);
        if( c!=null ) 
            g.setFill( c.r, c.g, c.b, c.a );
        else
            g.setFill( 0,0,0,0 );
    }

    public function getStyleTextFormat() :TextFormat {
        return style.get("font",TextFormat.getDefault() );
    }
}
