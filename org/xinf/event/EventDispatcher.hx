package org.xinf.event;

class EventDispatcher {
    static public var global:EventDispatcher = new EventDispatcher();
    static public function addGlobalEventListener( type:String, f:Event->Void ) :Void {
        global.addEventListener( type, f );
    }
    
    private var _listeners:Hash<Array<Event -> Void>>;
    
    public function new() :Void {
        _listeners = new Hash<Array<Event -> Void>>();
    }
    
    public function addEventListener( type:String, f:Event->Void ) :Void {
        var a:Array<Event->Void> = _listeners.get(type);
        if( a == null ) {
            a = new Array<Event->Void>();
            _listeners.set(type,a);
        }
        a.push(f);
    }

    public function removeEventListener( type:String, f:Event->Void ) :Void {
        var a:Array<Event->Void> = _listeners.get(type);
        if( a != null ) {
//            trace("remove EventListener "+type+": then "+a.length );
//            trace("remove EventListener "+type+": then "+a.length );
//            trace( a[0] +" vs "+ f );
            a.remove( f );
//            trace("remove EventListener "+type+": now  "+a.length );
        }
    }
    
    public function dispatchEvent( e:Event ) :Void {
        var a:Array<Event -> Void> = _listeners.get(e.type);
        if( a != null ) {
            for( listener in a ) {
                listener(e);
                if( e.stopped ) return;
            }
        }
        if( this != global ) global.dispatchEvent( e );
    }
    
    public function postEvent( type:String, data:Dynamic ) :Event {
        var e:Event = new Event( type, this, data );
        Event.push(e);
        return e;
    }
    
    public function hasListeners( type:String ) :Bool {
        var l:Array<Event->Void>;
        l = _listeners.get(type);
        if( l != null && l.length>0 ) return true;
        return false;
    }
}
