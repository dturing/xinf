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
    
    public property type(default,null) : String;
    public var key : String;
    
    public function new( t:String ) :Void {
        type = t;
    }
    
    public static function KeyboardEvent( type:String, key:String ) :Event {
        var e:Event = new Event( type );
        e.key = key;
        return e;
    }
}
