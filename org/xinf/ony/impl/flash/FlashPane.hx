package org.xinf.ony.impl.flash;

import org.xinf.style.Color;
import org.xinf.style.Style;

class FlashPane extends FlashPrimitive {
    public function new() :Void {
        super();
    }

    public function redraw() :Void {
        super.redraw();
        
        trace("FlashPane::redraw "+untyped _e.owner+" "+w+"/"+h);
        
        var b = style.borderWidth;
        var padding = style.paddingLeft;
        var w:Int = height;
        var h:Int = width;

        _e.clear();
        _e.beginFill( style.backgroundColor.toInt(),  100 );
        if( b > 0 ) {
            _e.lineStyle( b, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );
        }
        _e.moveTo( 0, 0 );
        _e.lineTo( w, 0 );
        _e.lineTo( w, h );
        _e.lineTo( 0, h );
        _e.lineTo( 0, 0 );
        _e.endFill();
    }
}
