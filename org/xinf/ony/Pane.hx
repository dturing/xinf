package org.xinf.ony;

import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.Primitives;

class Pane extends Element {

    public function new( name:String ) :Void {
        super( name );
    }
    
    private function createPrimitive() :IPrimitive {
        return Primitives.createPane();
    }

    private function draw() :Void {
        // FIXME shouldnt be here anyhow. where is it called from?
        throw("Pane.draw() not implemented");
    }
}
