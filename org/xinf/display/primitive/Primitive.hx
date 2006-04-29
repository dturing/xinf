package org.xinf.display.primitive;

class Primitive {
    public function new() {
    }

    public function _render( r:org.xinf.render.IRenderer ) {
        throw("org.xinf.display.primitive.Primitive is an abstract base class, it's _render function must be overwritten.");
    }
}
