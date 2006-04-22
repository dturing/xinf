package org.xinf.display.primitive;

class Primitive {
    public function new() {
    }

    public function _render( r:org.xinf.render.IRenderer ) {
        throw("org.xinf.display.primitive.Primitive is an abstract base class, its _render must be overwritten.");
    }
}
