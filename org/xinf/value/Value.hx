package org.xinf.value;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class ValueBase extends EventDispatcher {
    var lastChanged:Event;
    var active:Bool;
    
    public function new() :Void {
        super();
        active = false;
    }
    
    public function get() :Dynamic {
        return null;
    }
    public function set( v:Dynamic ) :Dynamic {
        return null;
    }
    public function fromString( s:String ) :Void {
    }

    public function addEventListener( type:String, f:Event->Void ) :Void {
        super.addEventListener( type, f );
        if( !active ) activate();
    }
    public function removeEventListener( type:String, f:Event->Void ) :Void {
        super.removeEventListener( type, f );
        if( active  ) deactivate(); // FIXME this is wrong, so wrong!
    }
    public function activate() :Void {
        active = true;
    }
    public function deactivate() :Void {
        active = false;
    }

    private function changed( _old:Dynamic, _new:Dynamic ) :Void {
        if( _new != _old && (lastChanged==null || lastChanged.stopped) )  {
            lastChanged = postEvent( "changed", { _old:_old, _new:_new } );
        }
    }
    private function onChildChanged( e:Event ) :Void {
        changed( 0, get() ); // FIXME
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
        changed( o, v );
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
        changed(0,get()); // FIXME
    }

    public function setLink( a:Value<T> ) :Void {
        linked.removeEventListener( "changed", listener );
        var old:T = linked.value;
        linked = a;
        listener = linkChanged;
        linked.addEventListener( "changed", listener );
        if( linked.value != old && old != null ) {
            changed( old, linked.value );
        }
    }

    public function toString() :String {
        return( "_"+linked );
    }
}
