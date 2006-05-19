package org.xinf.ony.impl.flash;

import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.geom.Point;
import flash.TextField;

import org.xinf.value.Value;
import org.xinf.value.Expression;
import org.xinf.value.ValueMonitor;
import org.xinf.event.Event;

class FlashText extends FlashPane, implements ITextPrimitive  {
    private var _t:TextField;

    private static var _monitors:Array<ValueMonitor>;
    
    public function new() :Void {
        _monitors = new Array<ValueMonitor>();
        
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

    public function setStyle( style:org.xinf.style.Style ) :Void {
        _monitors.push( new ValueMonitor( new Sum(untyped [
                            style.getLink("marginLeft"),
                            style.getLink("borderWidth"),
                            style.getLink("paddingLeft")
                            ]), null, _t, "_x" ) );
        _monitors.push( new ValueMonitor( new Sum(untyped [
                            style.getLink("marginTop"),
                            style.getLink("borderWidth"),
                            style.getLink("paddingRight")
                            ]), null, _t, "_y" ) );
        _monitors.push( new ValueMonitor(
                            style.getLink("color"), untyped org.xinf.style.Color.prototype.toInt, _t, "textColor" ) );
                            
                            trace("ValueMonitors: "+_monitors.length );

        super.setStyle(style);
    }
    
    public function setText( text:String ) :Void {
        _t.text = text;
    }

    public function getTextExtends() :Point {
        return( new Point(_t._width,_t._height) );
    }
}
