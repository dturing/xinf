package org.xinf.event;

class Event {
    public static var RENDER:String = "render";
    public static var ENTER_FRAME:String = "enterFrame";
    
    public property type(default,null) : String;
    public property bubbles(default,null) : Bool;
    public property cancelable(default,null) : Bool;
    
    public property propagate(default,default) : Bool;

    public property target(default,default) : Dynamic;
    public property currentTarget(default,default) : Dynamic;
    public property eventPhase(_get_nyi,null) : Int; // SHOULD be int, enum or class?
    public function _get_nyi() : Dynamic {
        throw("NYI");
    }
    
    public function new( t:Dynamic ) {
        type = t.type;
        bubbles = t.bubbles;
        cancelable = t.cancelable;
        target = t.target;
        propagate = false;
    }
}
