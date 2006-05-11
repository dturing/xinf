package org.xinf.ony;

import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.Primitives;

class Image extends Pane {

    public function new( name:String ) {
        super(name);
    }
    
    private function createPrimitive() :IPrimitive {
        return Primitives.createImage();
    }
}
