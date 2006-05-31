package org.xinf.ony.impl.flash;

import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.geom.Point;
import flash.TextField;

class FlashText extends FlashPane, implements ITextPrimitive  {
    private var _t:TextField;

    public function new() :Void {
        super();
        _e.createTextField( 
            "_XinfonyTextField", _e.getNextHighestDepth(), 0, 0, 100, 100 );

        _t = _e._XinfonyTextField;
        _t.autoSize = true;

        var format:flash.TextFormat = new flash.TextFormat();
        format.size = 12;
        format.font = "Bitstream Vera Sans";
        _t.setNewTextFormat( format );
        
    }

    public function setText( text:String ) :Void {
        _t.text = text;
    }

    public function getTextExtends() :Point {
        return( new Point(_t._width,_t._height) );
    }
}
