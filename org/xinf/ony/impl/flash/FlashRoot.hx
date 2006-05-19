package org.xinf.ony.impl.flash;

import org.xinf.ony.impl.IRootPrimitive;

class FlashRoot extends FlashPrimitive, implements IRootPrimitive {
    public function new() :Void {
        super();
    }
    
    public function run() :Void {
        _e.onEnterFrame = step;
    }
    
    public function step() :Void {
        org.xinf.event.Event.processQueue();
    }
}
