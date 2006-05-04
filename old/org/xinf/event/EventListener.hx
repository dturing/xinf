package org.xinf.event;

class EventListener {
    private var f : Event->Void;
    private var priority : Int;

    public function new( _f: Event->Void, _priority:Int ) {
        f = _f;
        priority = _priority;
    }
    
    public function dispatchEvent( e:Event ) : Void {
        f( e );
    }
    
    public function isFunction( _f: Event->Void ) : Bool {
        return( _f == f );
    }
}
