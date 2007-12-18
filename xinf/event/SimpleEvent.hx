/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    SimpleEvent is an Event that carries no further data.
**/
class SimpleEvent extends Event<SimpleEvent> {
    
/** quit application **/
    static public var QUIT = new EventKind<SimpleEvent>("quit");

/** something has changed **/
    static public var CHANGED = new EventKind<SimpleEvent>("changed");

    public function new( _type:EventKind<SimpleEvent> ) {
        super(_type);
    }
    
}
