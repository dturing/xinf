package xinf.style;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

class StyleElement extends xinf.ony.Object {
    public var style :Style;
    public var assignedStyle :Style;
    public var ownStyle :Style;
    
    public function new() :Void {
        super();
        style = StyleSheet.newDefaultStyle();
    }

    public function assignStyle( s:Style ) {
        if( s!=assignedStyle ) {
            assignedStyle = s;
            updateStyle();
        }
    }

    public function setStyle( s:Style ) {
        if( s!=ownStyle ) {
            ownStyle = s;
            updateStyle();
        }
    }

    public function updateStyle() {
        if( ownStyle!=null && assignedStyle!=null ) {
            style = new Style();
            style.setFrom( assignedStyle );
            style.setFrom( ownStyle );
        } else if( assignedStyle!=null ) {
            style = assignedStyle;
        } else if( ownStyle!=null ) {
            style = ownStyle;
        }
        styleChanged( style );
        scheduleRedraw();
    }
    
    public function styleChanged( style:Style ) {
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
    public function innerTopLeft() :{x:Float,y:Float} {
        if( style==null ) return {x:0.,y:0.};
        return({ x:style.padding.l+style.border.l, y:style.padding.t+style.border.t });
    }
    public function leftOffsetAligned(pref:Float,align:Float) :Float {
        var l = style.padding.l+style.border.l;
        var iw = size.x;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }
    public function topOffsetAligned(pref:Float,align:Float) :Float {
        var l = style.padding.t+style.border.t;
        var iw = size.y;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }
}
