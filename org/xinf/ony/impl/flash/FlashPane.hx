package org.xinf.ony.impl.flash;

import org.xinf.style.Color;
import org.xinf.style.Style;

class FlashPane extends FlashPrimitive {
    public function new() :Void {
        super();
    }
    
    public function setStyle(style:Style) :Void {
        super.setStyle(style);
        style.addEventListener("changed", untyped scheduleRedraw );
    }

    public function redraw() :Void {
        super.redraw();
        
//        trace("FlashPane::redraw "+untyped _e.owner+" "+w+"/"+h);

        var x:Int = Math.round( style.marginLeft );        
        var y:Int = Math.round( style.marginTop );
        var w:Int = Math.round( width - style.marginRight );
        var h:Int = Math.round( height - style.marginBottom );

        _e.clear();
        _e.beginFill( style.backgroundColor.toInt(),  100 );
        if( style.borderStyle != "none" ) {
            _e.lineStyle( style.borderWidth, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );
        }
        _e.moveTo( x, y );
        _e.lineTo( w, y );
        _e.lineTo( w, h );
        _e.lineTo( x, h );
        _e.lineTo( x, y );
        _e.endFill();
    }
}
