/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

import xinf.event.EventKind;
import xinf.event.Event;
import xinf.event.EventDispatcher;

class FrameEvent extends Event<FrameEvent> {
    
    static public var ENTER_FRAME = new EventKind<FrameEvent>("enterFrame");

    public var frame:Int;
    
    public function new( _type:EventKind<FrameEvent>, frame:Int ) {
        super(_type);
        this.frame = frame;
    }
    
}
