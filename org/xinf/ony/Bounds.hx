package org.xinf.ony;

import org.xinf.value.Value;
import org.xinf.event.Event;

class Bounds extends ValueBase {
    public property x(get_x,set_x):Float;
    public var _x:Identity<Float>; // FIXME: private, maybe?
    private function get_x():Float {
        return _x.get_value();
    }
    private function set_x( v:Float ):Float {
        _x.set( new Value<Float>(v) );
        return _x.get_value();
    }
    
    public property y(get_y,set_y):Float;
    public var _y:Identity<Float>; // FIXME: private, maybe?
    private function get_y():Float {
        return _y.get_value();
    }
    private function set_y( v:Float ):Float {
        _y.set( new Value<Float>(v) );
        return _y.get_value();
    }

    public property width(get_width,set_width):Float;
    public var _width:Identity<Float>; // FIXME: private, maybe?
    private function get_width():Float {
        return _width.get_value();
    }
    private function set_width( v:Float ):Float {
        _width.set( new Value<Float>(v) );
        return _width.get_value();
    }

    public property height(get_height,set_height):Float;
    public var _height:Identity<Float>; // FIXME: private, maybe?
    private function get_height():Float {
        return _height.get_value();
    }
    private function set_height( v:Float ):Float {
        _height.set( new Value<Float>(v) );
        return _height.get_value();
    }
    
    public function new( l:Float, t:Float, r:Float, b:Float ) {
        super();
        _x = new Identity<Float>( new Value<Float>( l ) );
        _y = new Identity<Float>( new Value<Float>( l ) );
        _width = new Identity<Float>( new Value<Float>( r ) );
        _height = new Identity<Float>( new Value<Float>( l ) );
        
        _x.addEventListener( "changed", onChildChanged );
        _y.addEventListener( "changed", onChildChanged );
        _width.addEventListener( "changed", onChildChanged );
        _height.addEventListener( "changed", onChildChanged );
    }
        
    public static function newZero() :Bounds {
        return new Bounds(.0,.0,.0,.0);
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+width+"x"+height+")");
    }
}
