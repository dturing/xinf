package org.xinf.ony.impl.flash;

import org.xinf.ony.impl.IRootPrimitive;
import org.xinf.event.Event;

class FlashRoot extends FlashPrimitive, implements IRootPrimitive {
    public function new() :Void {
        super();
    }
    
    public function run() :Void {
        _e.onEnterFrame = step;
    }
    
    public function step() :Void {
        org.xinf.event.EventDispatcher.global.postEvent( Event.ENTER_FRAME, { } );
        org.xinf.event.Event.processQueue();
    }
}
