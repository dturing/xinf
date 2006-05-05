package xinfony.event;

class EventDispatcher {
    static var global:EventDispatcher = new EventDispatcher();
    static function addGlobalEventListener( type:String, f:Event->Bool ) :Void {
        global.addEventListener( type, f );
    }
    static function dispatchGlobalEvent( Event e ) :Bool {
        return global.dispatchEvent( e );
    }
    
    private var _listeners:Hash<Array<Event -> Bool>>;
    
    public function new() {
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
        if( a == null ) {
            for( listener in a ) {
                if( !a(e) ) return false;
            }
        }
        return true;
    }
}
