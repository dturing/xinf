package org.xinf.event;

class Event {
    public static var ENTER_FRAME:String = "enterFrame";
    
    public static var MOUSE_DOWN:String = "mouseDown";
    public static var MOUSE_UP:String = "mouseUp";
    public static var MOUSE_MOVE:String = "mouseMove";
    public static var MOUSE_OVER:String = "mouseOver";
    public static var MOUSE_OUT:String = "mouseOut";

    public static var KEY_DOWN:String = "keyDown";
    public static var KEY_UP:String = "keyUp";
    
    public static var STYLE_CHANGED:String = "styleChanged";
    public static var SIZE_CHANGED:String = "sizeChanged";
    
    public static var CHANGED:String = "changed";
    
    public property type(default,null) : String;
    public property target(default,null) : EventDispatcher;
    public property stopped(default,null) : Bool;
    public var key : String;
    
    
    public function new( _type:String, _target:EventDispatcher ) :Void {
        type = _type;
        target = _target;
        stopped = false;
    }
    
    public function stopPropagation() :Void {
        stopped = true;
    }
    
    public static function KeyboardEvent( type:String, target:EventDispatcher, key:String ) :Event {
        var e:Event = new Event( type, target );
        e.key = key;
        return e;
    }
}
