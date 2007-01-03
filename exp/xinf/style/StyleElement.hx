package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.Color;

class StyleElement extends xinf.ony.Object {
    
    public var style :Style;
    
    public function new() :Void {
        super();
        style = StyleSheet.newDefaultStyle();
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

    public function setStyleFont( g:Renderer ) :Void {
        var fontName = style.get("fontFamily","_sans");
        if( fontName != null ) {
            g.setFont( fontName, style.get("fontSlant",false),
                    style.get("fontWeight",false),
                    style.get("fontSize",12) );
        }
    }
}
