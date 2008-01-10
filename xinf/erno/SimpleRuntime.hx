/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.event.SimpleEventDispatcher;
import xinf.event.EventKind;
import xinf.event.FrameEvent;
import xinf.erno.Renderer;

/** DOCME */
class SimpleRuntime extends Runtime {
    
    private var nextId:Int;
    
    public function new() :Void {
        super();
        nextId=1;
    }
    
    override public function getNextId() :Int {
        return nextId++;
    }
    
}
