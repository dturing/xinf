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
        if( s!=style ) {
            style = s;
            scheduleRedraw();
        }
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
    
    public function removePadding( t:{x:Float,y:Float} ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: t.x - (style.padding.l+style.padding.r + style.border.l+style.border.r),
                 y: t.y - (style.padding.t+style.padding.b + style.border.t+style.border.b) });
    }
    public function addPadding( t:{x:Float,y:Float} ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: t.x + (style.padding.l+style.padding.r + style.border.l+style.border.r), 
                 y: t.y + (style.padding.t+style.padding.b + style.border.t+style.border.b) });
    }
    public function clampSize( t:{x:Float,y:Float} ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: Math.max( style.get("minWidth",0), Math.min( style.get("maxWidth", Math.POSITIVE_INFINITY), t.x )),
                 y: Math.max( style.get("minHeight",0), Math.min( style.get("maxHeight", Math.POSITIVE_INFINITY), t.y )) });
        
    }
}
