package org.xinf.ony;

import org.xinf.value.Value;
import org.xinf.event.Event;

class Bounds extends ValueBase {
    public property x(get_x,set_x):Float;
    private var __x:Value<Float>;
    public var _x:Identity<Float>; // FIXME: private, maybe?
    private function get_x():Float {
        return _x.get_value();
    }
    private function set_x( v:Float ):Float {
        __x.value = v;
        return v;
    }
    
    public property y(get_y,set_y):Float;
    private var __y:Value<Float>;
    public var _y:Identity<Float>; // FIXME: private, maybe?
    private function get_y():Float {
        return _y.get_value();
    }
    private function set_y( v:Float ):Float {
        __y.value = v;
        return v;
    }

    public property width(get_width,set_width):Float;
    private var __width:Value<Float>;
    public var _width:Identity<Float>; // FIXME: private, maybe?
    private function get_width():Float {
        return _width.get_value();
    }
    private function set_width( v:Float ):Float {
        __width.value = v;
        return v;
    }

    public property height(get_height,set_height):Float;
    private var __height:Value<Float>;
    public var _height:Identity<Float>; // FIXME: private, maybe?
    private function get_height():Float {
        return _height.get_value();
    }
    private function set_height( v:Float ):Float {
        __height.value = v;
        return v;
    }
    
/*
    private static var _zero:Value<Float>;
    public static function __init__() :Void {
        _zero = new Value<Float>();
        _zero.value = 0;
    }
*/    

    private function positionChanged( e:Event ) :Void {
        postEvent( "positionChanged", { x:_x.value, y:_y.value } );
    }
    private function sizeChanged( e:Event ) :Void {
        postEvent( "sizeChanged", { width:_width.value, height:_height.value } );
    }

    public function new() {
        super();
        __x = new Value<Float>();
        __x.value = .0;
        _x = new Identity<Float>( __x );
        __y = new Value<Float>();
        __y.value = .0;
        _y = new Identity<Float>( __y );
        __width = new Value<Float>();
        __width.value = .0;
        _width = new Identity<Float>( __width );
        __height = new Value<Float>();
        __height.value = .0;
        _height = new Identity<Float>( __height );
        
        
        // FIXME: wow! really do this?
        _x.addEventListener( "changed", positionChanged );
        _y.addEventListener( "changed", positionChanged );
        _width.addEventListener( "changed", sizeChanged );
        _height.addEventListener( "changed", sizeChanged );
        addEventListener( "positionChanged", onChildChanged );
        addEventListener( "sizeChanged", onChildChanged );
    }
        
    public static function newZero() :Bounds {
        var b = new Bounds();
        return b;
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+width+"x"+height+")");
    }
}
