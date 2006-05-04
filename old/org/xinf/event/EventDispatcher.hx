package org.xinf.event;

import org.xinf.event.IEventDispatcher;

class EventDispatcher implements IEventDispatcher {
    private var target : IEventDispatcher;
    private var listeners : Hash<Array<EventListener>>;

    public function new( _target:IEventDispatcher ) {
        target = _target;
        listeners = new Hash<Array<EventListener>>();
    }

    public function addEventListener( type:String, f : Event->Void, 
                               useCapture:Bool, priority:Int, 
                               weakRef:Bool ) {
         if( weakRef ) throw("weak referencing NYI");
         if( useCapture ) throw("useCapture NYI");
         
         var h:Array<EventListener> = listeners.get(type);
         if( h == null ) h = new Array<EventListener>();
         
         var l:EventListener = _findListener( h, f );
         if( l == null ) l = new EventListener( f, priority );
         else throw("listener exists, override NYI");
         
         // TODO: sort h by priority
         
         h.push( l );
         listeners.set(type,h);
    }                        
   
    private function _findListener( h : Array<EventListener>, f : Event->Void ) : EventListener {
        for( l in h ) {
            if( l.isFunction(f) ) return l;
        }
        return null;
    }
                               
    public function dispatchEvent( e:Event ) : Bool {
        var h:Array<EventListener> = listeners.get(e.type);
        if( h != null ) {
            for( listener in h ) {
                e.currentTarget = this;
                listener.dispatchEvent(e);
            }
            
            // TODO: bubble? stuff like that?
            
            return true;
    //    } else {
    //        trace("unhandled "+e.type );
        }
        
        return true;
    }
    
    public function hasEventListener( type:String ) : Bool {
        return( listeners.get(type) != null );
    }
    
    public function removeEventListener( type:String, listener : Event->Void, useCapture:Bool ) : Void {
        throw("NYI");
    }
                                  
    public function willTrigger( type:String ) : Bool {
        // FIXME: probably not quite right.
        return( hasEventListener(type) );
    }
}
