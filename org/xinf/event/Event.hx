package org.xinf.event;

class Event {
    static public var queue:Array<Event>;
    static public function push( e:Event ) :Void {
        if( queue == null ) queue = new Array<Event>();
        queue.push(e);
    }
    static public function processQueue() :Void {
        if( queue == null ) return;
        var e:Event = queue.shift();
       // if( queue.length > 0 ) trace("processQueue: "+queue.length+" events" );
        
        if( queue.length > 50 ) {
            trace( queue.length+" is an astonishing number of events, breakdown: ");
            
            var h = new Hash<Int>();
            for( event in queue ) {
                var t:String = event.type;
                var i:Int = h.get(t);
                if( i==null ) i=0;
                i++;
                h.set(t,i);
            }
            
            for( type in h.keys() ) {
                trace( h.get(type) + "\t:"+type );
            }
        }
        
        var n=0;
        while( e != null ) {
            n++;
            e.target.dispatchEvent( e );
            e=queue.shift();
        }
        if( n>100 ) {
            trace("event queue processed "+n+" Events total");
        }
    }

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
