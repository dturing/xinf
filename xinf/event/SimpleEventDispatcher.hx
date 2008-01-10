/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

class SimpleEventDispatcher implements EventDispatcher {
    
    private var listeners :Hash<List<Dynamic->Void>>;
    private var filters :List<Dynamic->Bool>;

    public function new() :Void {
        listeners = new Hash<List<Dynamic->Void>>();
    }

    public function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void {
        var t = type.toString();
        var l = listeners.get( t.toString() );
        if( l==null ) {
            l = new List<Dynamic->Void>();
            listeners.set( t, l );
        }
        l.push( h );
        return h;
    }

    public function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
        var l:List<Dynamic->Void> = listeners.get( type.toString() );
        if( l!=null ) {
            return( l.remove(h) );
        }
        return false;
    }

    public function removeAllListeners<T>( type :EventKind<T> ) :Bool {
        return( listeners.remove( type.toString() ) );
    }

    public function addEventFilter( f:Dynamic->Bool ) :Void {
        if( filters==null ) filters=new List<Dynamic->Bool>();
        filters.push(f);
    }

    public function dispatchEvent<T>( e : Event<T> ) :Void {
        var l:List<Dynamic->Void> = listeners.get( e.type.toString() );
        var dispatched:Bool = false;
        
        if( filters!=null ) {
            for( f in filters ) {
                if( f(e)==false ) return;
            }
        }
        
        if( l != null ) {
            for( h in l ) {
                h(e);
                dispatched=true;
            }
        }
    }

	function copyProperties( to:Dynamic ) :Void {
		to.listeners = new Hash<List<Dynamic->Void>>();
		for( e in listeners.keys() ) {
			var v = listeners.get(e);
            var l = new List<Dynamic->Void>();
			for( i in v ) {
				l.add(i);
			}
            to.listeners.set( e, l );
		}
	}

    public function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void {
        // FIXME if debug_events
        e.origin = pos;
        
        // for now, FIXME (maybe, put them thru a global queue)
        dispatchEvent(e);
    }
    
}
