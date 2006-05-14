package org.xinf.value;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class Value extends EventDispatcher {
    private var _value:Float;
    public property value( get_value, set_value ):Float;

    public function new( v:Float ) {
        super();
        _value = v;
    }
    
    public function set_value( v:Float ) :Float {
        _value=v;
        changed();
        return _value;
    }
    public function get_value() :Float {
        return _value;
    }
    
    // FIXME: if refactoring of Style to use Values turns out good, replace all px() bullcrap..
    public function px() :Float {
        return value;
    }        
    
    private function changed() :Void {
        this.dispatchEvent( new Event( Event.CHANGED, this ) );
    }
    
    public function toString() :String {
        return( ""+get_value() );
    }
}
