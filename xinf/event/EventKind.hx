/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    An EventKind instance uniquely identifies a certain kind of Events
    (like, eg, MOUSE_DOWN). It couples the kind to a certain class of Event,
    and a unique string identifier.
**/
class EventKind<T> {
    
    public var name(default,null) :String;
    public var bubble(default,null) :Bool;
	
    public function new( name:String, ?bubble:Bool ) {
        this.name = name;
		if( bubble==null ) bubble=false;
		this.bubble = bubble;
    }
    
    public function toString() {
        return name;
    }
    
}
