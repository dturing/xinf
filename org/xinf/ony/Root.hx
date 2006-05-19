package org.xinf.ony;

import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.IRootPrimitive;
import org.xinf.ony.impl.Primitives;

class Root extends Element {
    private var _r:IRootPrimitive;

    private function new() {
        super("root");
    }
    
    private function createPrimitive() :IPrimitive {
        _r = Primitives.createRoot();
        return _r;
    }
    
    public static function getRoot() : Root {
        if( root == null ) {
            root = new Root();
        }
        return root;
    }
    
    public function run() : Void {
        _r.run();
    }
    
    public static var root:Root;
}
