package xinfony;

class Event {
    public static var ENTER_FRAME:String = "enterFrame";
    
    public property type(default,null) : String;
    
    public function new( t:String ) {
        type = t;
    }
}
