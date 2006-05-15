package org.xinf.value;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class Value<T> extends EventDispatcher, implements IValue {
    private var _value:T;
    public property value( get_value, set_value ):T;

    public function new( v:T ) {
        super();
        _value = v;
    }
    
    public function set_value( v:T ) :T {
        _value=v;
        changed();
        return _value;
    }
    public function get_value() :T {
        return _value;
    }

    // FIXME: if refactoring of Style to use Values turns out good, replace all px() bullcrap..
    public function px() :Float {
        return cast(value,Float);
    }        
    
    private function changed() :Void {
        this.dispatchEvent( new Event( "changed", this ) );
    }
    
    public function identity() :IValue {
        return( new Identity<T>( this ) );
    }
    
    public function toString() :String {
        return( "Value("+get_value()+")" );
    }
}

class Identity<T> extends Value<T> {
    private var linked:Value<T>;
    public function new( a:Value<T> ) {
        super(a._value);
        linked = a;
        a.addEventListener( "changed", linkChanged );
    }

    public function set_value( v:T ) :T {
        throw("Identity values can (currently) not be set.");
        return _value;
    }

    public function get_value() :T {
        return linked._value;
    }

    public function linkChanged( e:Event ) :Void {
        changed();
    }

    public function set( a:Value<T> ) :Void {
        // FIXME linked.removeEventListener()
        linked = a;
        a.addEventListener( "changed", linkChanged );
        changed();
    }
}
