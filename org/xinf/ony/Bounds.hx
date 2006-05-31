package org.xinf.ony;

import org.xinf.value.Value;
import org.xinf.event.Event;

class Bounds extends ValueBase {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public function new() {
        super();
        x = y = width = height = .0;
    }

    public function setPosition( _x:Float, _y:Float ) :Void {
        x = _x;
        y = _y;
        postEvent( "positionChanged", { x:x, y:y } );
    }
    public function setSize( _width:Float, _height:Float ) :Void {
        width = _width;
        height = _height;
        postEvent( "sizeChanged", { width:width, height:height } );
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+width+"x"+height+")");
    }
}
