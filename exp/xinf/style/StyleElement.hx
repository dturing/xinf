package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

class StyleElement extends xinf.ony.Container<xinf.ony.Object> {
    
    public var style :Style;
    public var innerSize(default,null):{x:Float,y:Float};
    public var innerPos(default,null):{x:Float,y:Float};
    
    public function new() :Void {
        super();
        style = StyleSheet.newDefaultStyle();
    }
    

    public function applyStyle( s:Style ) {
        style = s;
        
        // resize to same inner size, in case padding has changed
        if( innerSize!=null ) resizeInner(innerSize.x,innerSize.y);
        
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
    
    override public function resize( x:Float, y:Float ) :Void {
        super.resize( x, y );
        
        innerSize = {
            x:x - (style.padding.l+style.padding.r+style.border.l+style.border.r),
            y:y - (style.padding.t+style.padding.b+style.border.t+style.border.b) };
        innerPos = {
            x:style.padding.l,
            y:style.padding.t };
    }
    public function resizeInner( x:Float, y:Float ) :Void {
        resize( x + style.padding.l+style.padding.r + style.border.l+style.border.r, 
                y + style.padding.t+style.padding.b + style.border.t+style.border.b );
    }
}
