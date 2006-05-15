package org.xinf.ony;

import org.xinf.ony.impl.IPrimitive;

class Wrapper extends Pane {

    private var _primitive:IPrimitive;
    
    public function new( name:String, p:IPrimitive ) {
        _primitive = p;
        super(name);
    }
    
    private function createPrimitive() :IPrimitive {
        return _primitive;
    }
}
