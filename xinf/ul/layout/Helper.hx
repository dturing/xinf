/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Component;

class Helper {
    public static function removePadding( t:{x:Float,y:Float}, c:Component ) :{x:Float,y:Float} {
        if( c==null ) return t;
        return({ x: t.x - (c.padding.l+c.padding.r + c.border.l+c.border.r),
                 y: t.y - (c.padding.t+c.padding.b + c.border.t+c.border.b) });
    }
    public static function addPadding( t:{x:Float,y:Float}, c:Component ) :{x:Float,y:Float} {
        if( c==null ) return t;
        return({ x: t.x + (c.padding.l+c.padding.r + c.border.l+c.border.r), 
                 y: t.y + (c.padding.t+c.padding.b + c.border.t+c.border.b) });
    }

    public static function clampSize( t:{x:Float,y:Float}, c:Component ) :{x:Float,y:Float} {
	    if( c==null ) return t;
        return({ x: Math.max( c.minWidth, Math.min( c.maxWidth, t.x )),
                 y: Math.max( c.minHeight, Math.min( c.maxHeight, t.y )) });
        
    }
	
    public static function leftOffsetAligned( c:Component, space:Float, align:Float ) :Float {
        var l = c.padding.l+c.border.l;
        var iw = space;
		var pref = c.prefSize.x;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }

	public static function topOffsetAligned( c:Component, space:Float, align:Float ) :Float {
        var l = c.padding.t+c.border.t;
        var iw = space;
		var pref = c.prefSize.y;
        if( pref < iw ) {
            l += align * (iw-pref);
        }
        return l;
    }
	
    public static function innerTopLeft( c:Component ) :{x:Float,y:Float} {
        if( c==null ) return {x:0.,y:0.};
        return({ x:c.padding.l+c.border.l, y:c.padding.t+c.border.t });
    }
}
