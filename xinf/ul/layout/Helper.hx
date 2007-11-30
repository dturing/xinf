package xinf.ul.layout;

import xinf.ul.ComponentStyle;
import xinf.ul.Component;

class Helper {
    public static function removePadding( t:{x:Float,y:Float}, style:ComponentStyle ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: t.x - (style.padding.l+style.padding.r + style.border.l+style.border.r),
                 y: t.y - (style.padding.t+style.padding.b + style.border.t+style.border.b) });
    }
    public static function addPadding( t:{x:Float,y:Float}, style:ComponentStyle ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: t.x + (style.padding.l+style.padding.r + style.border.l+style.border.r), 
                 y: t.y + (style.padding.t+style.padding.b + style.border.t+style.border.b) });
    }

    public static function clampSize( t:{x:Float,y:Float}, style:ComponentStyle ) :{x:Float,y:Float} {
        if( style==null ) return t;
        return({ x: Math.max( style.minWidth, Math.min( style.maxWidth, t.x )),
                 y: Math.max( style.minHeight, Math.min( style.maxHeight, t.y )) });
        
    }
	
    public static function leftOffsetAligned( c:Component, space:Float, align:Float ) :Float {
        var l = c.style.padding.l+c.style.border.l;
        var iw = space;
		var pref = c.prefSize.x;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }

	public static function topOffsetAligned( c:Component, space:Float, align:Float ) :Float {
        var l = c.style.padding.t+c.style.border.t;
        var iw = space;
		var pref = c.prefSize.y;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }
	
    public static function innerTopLeft( style:ComponentStyle ) :{x:Float,y:Float} {
        if( style==null ) return {x:0.,y:0.};
        return({ x:style.padding.l+style.border.l, y:style.padding.t+style.border.t });
    }
}
