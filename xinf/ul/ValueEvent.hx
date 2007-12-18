/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import xinf.event.Event;

class ValueEvent<Value> extends Event<ValueEvent<Value>> {
    
    static public var VALUE = new xinf.event.EventKind<ValueEvent<Value>>("value");

    public var value:Value;
    
    public function new( _type:xinf.event.EventKind<ValueEvent<Value>>, value:Value ) {
        super(_type);
        this.value = value;
    }
    
}
