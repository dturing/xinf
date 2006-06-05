package org.xinf.ony;

class Wrapper extends Pane {
    var _primitive:Dynamic;
    
    public function new( name:String, parent:Element, p:Dynamic ) {
        _primitive = p;
        super(name,parent);
    }
    
    private function createPrimitive() :Dynamic {
        return _primitive;
    }
}
