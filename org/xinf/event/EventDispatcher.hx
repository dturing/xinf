package org.xinf.event;

class EventDispatcher {
    static public var global:EventDispatcher = new EventDispatcher();
    static public function addGlobalEventListener( type:String, f:Event->Bool ) :Void {
        global.addEventListener( type, f );
    }
    
    private var _listeners:Hash<Array<Event -> Bool>>;
    
    public function new() :Void {
        _listeners = new Hash<Array<Event -> Bool>>();
    }
    
    public function addEventListener( type:String, f:Event->Bool ) :Void {
        var a:Array<Event->Bool> = _listeners.get(type);
        if( a == null ) {
            a = new Array<Event->Bool>();
            _listeners.set(type,a);
        }
        a.push(f);
    }
    
    public function dispatchEvent( e:Event ) : Bool {
        var a:Array<Event->Bool> = _listeners.get(e.type);
        if( a != null ) {
            for( listener in a ) {
                if( !listener(e) ) return false;
            }
        }
        if( this != global ) global.dispatchEvent( e );
        return true;
    }
}
