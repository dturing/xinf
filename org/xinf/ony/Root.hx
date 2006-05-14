package org.xinf.ony;

import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.Primitives;

class Root extends Element {

    private function new() {
        super("root");
    }
    
    private function createPrimitive() :IPrimitive {
        return Primitives.createRoot();
    }
    
    public static function getRoot() : Root {
        if( root == null ) {
            root = new Root();
        }
        return root;
    }
    
    public static var root:Root;
}
