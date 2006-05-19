package org.xinf.ony.impl.flash;

import org.xinf.style.Color;
import org.xinf.style.Style;

class FlashPane extends FlashPrimitive {
    public function new() :Void {
        super();
    }

    public function redraw() :Void {
        super.redraw();
        
        var b = style.borderWidthLeft;
        var padding = style.paddingLeft;
        var w:Int = Math.floor( bounds.width );
        var h:Int = Math.floor( bounds.height );

        _e.clear();
        _e.beginFill( style.background.toInt(),  100 );
        if( b > 0 ) {
            _e.lineStyle( b, style.border.color.toInt(), style.border.color.a*100, true, "", "", "", 0 );
        }
        _e.moveTo( 0, 0 );
        _e.lineTo( w, 0 );
        _e.lineTo( w, h );
        _e.lineTo( 0, h );
        _e.lineTo( 0, 0 );
        _e.endFill();
    }
}
