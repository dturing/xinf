package xinfony.event;

class MouseEvent extends Event {
    public static var MOUSE_DOWN:String = "mouseDown";
    public static var MOUSE_UP:String = "mouseUp";
    public static var MOUSE_MOVE:String = "mouseMove";
    public static var MOUSE_OVER:String = "mouseOver";
    public static var MOUSE_OUT:String = "mouseOut";
    
    public property stageX(default,null):Int;
    public property stageY(default,null):Int;
    
    public function new( t:Dynamic ) {
        super( t );
        stageX = t.stageX;
        stageY = t.stageY;
    }
            
}
