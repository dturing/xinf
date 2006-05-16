package org.xinf.value;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class ValueBase extends EventDispatcher {
    public function get() :Dynamic {
        return null;
    }
    public function set( v:Dynamic ) :Dynamic {
        return null;
    }
    public function fromString( s:String ) :Void {
    }

    private function changed() :Void {
        this.dispatchEvent( new Event( "changed", this ) );
    }
    private function onChildChanged( e:Event ) :Void {
        this.dispatchEvent( new Event( "changed", this ) );
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
        _value=v;
        changed();
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

    // FIXME: if refactoring of Style to use Values turns out good, replace all px() bullcrap..
    public function px() :Float {
        return cast(value,Float);
    }        
    
    public function toString() :String {
        return( ""+get_value() );
    }
    
    public function identity() :ValueBase {
        return( new Identity<T>( this ) );
    }
}

class Identity<T> extends Value<T> {
    private var linked:Value<T>;
    public function new( a:Value<T> ) {
        super();
        linked = a;
        a.addEventListener( "changed", linkChanged );
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
        // FIXME linked.removeEventListener()
        var old:T = linked.value;
        linked = a;
        a.addEventListener( "changed", linkChanged );
        if( a.value != old ) changed();
    }

    public function toString() :String {
        return( "_"+linked );
    }
}
