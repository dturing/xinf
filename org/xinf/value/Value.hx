package org.xinf.value;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class ValueBase extends EventDispatcher {
    var lastChanged:Event;
    
    public function new() :Void {
        super();
    }
    
    public function get() :Dynamic {
        return null;
    }
    public function set( v:Dynamic ) :Dynamic {
        return null;
    }
    public function fromString( s:String ) :Void {
    }

    private function changed() :Void {
        if( lastChanged==null || lastChanged.stopped ) 
            lastChanged = postEvent( "changed", null );
    }
    private function onChildChanged( e:Event ) :Void {
        changed();
    }

    public function identity() :ValueBase {
        return null;
    }
}

class Value<T> extends ValueBase {
    private var _value:T;
    public property value( get_value, set_value ):T;

    public function new() {
        super();
    }
    
    public function set_value( v:T ) :T {
        var o:T = _value;
        _value=v;
        if( o != v && o != null ) changed();
        return _value;
    }
    public function get_value() :T {
        return _value;
    }

    public function get() :Dynamic {
        return get_value();
    }
    public function set( v:Dynamic ) :Dynamic {
        return set_value( v );
    }
   
    public function toString() :String {
        return( ""+get_value() );
    }
    
    public function identity() :ValueBase {
        return( new Identity<T>( this ) );
    }
}

class Identity<T> extends Value<T> {
    private var listener:Dynamic;
    
    private var linked:Value<T>;
    public function new( a:Value<T> ) {
        super();
        linked = a;
        listener = linkChanged;
        a.addEventListener( "changed", listener );
    }

    public function set_value( v:T ) :T {
        throw("Identity values can (currently) not be set.");
        return null;
    }

    public function get_value() :T {
        return linked.value;
    }

    public function linkChanged( e:Event ) :Void {
        changed();
    }

    public function setLink( a:Value<T> ) :Void {
        linked.removeEventListener( "changed", listener );
        var old:T = linked.value;
        linked = a;
        listener = linkChanged;
        linked.addEventListener( "changed", listener );
        if( linked.value != old && old != null ) {
            changed();
        }
    }

    public function toString() :String {
        return( "_"+linked );
    }
}
