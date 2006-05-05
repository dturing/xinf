package xinf.event;

class Event {
    public static var ENTER_FRAME:String = "enterFrame";
    
    public static var MOUSE_DOWN:String = "mouseDown";
    public static var MOUSE_UP:String = "mouseUp";
    public static var MOUSE_MOVE:String = "mouseMove";
    public static var MOUSE_OVER:String = "mouseOver";
    public static var MOUSE_OUT:String = "mouseOut";
    
    public property type(default,null) : String;
    
    public function new( t:String ) {
        type = t;
    }
}
