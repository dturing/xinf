package org.xinf.ony.impl.flash;

class FlashPane extends FlashPrimitive {
    public function new() :Void {
        super();
    }
    
    public function redraw() :Void {
        super.redraw();

        var x:Int = 0;
        var y:Int = 0;
        var w:Int = bounds.width;
        var h:Int = bounds.height;

        _e.clear();
        _e.beginFill( 0xff0000,  100 );

//            _e.lineStyle( style.borderWidth, style.borderColor.toInt(), style.borderColor.a*100, true, "", "", "", 0 );

        _e.moveTo( x, y );
        _e.lineTo( w, y );
        _e.lineTo( w, h );
        _e.lineTo( x, h );
        _e.lineTo( x, y );
        _e.endFill();
    }
}
