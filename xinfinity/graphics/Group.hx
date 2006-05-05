package xinfinity.graphics;

class Group extends Object {
    private var children:Array<Object>;
    
    public function new() {
        super();
        children = new Array<Object>();
    }

    public function appendChild( child:Object ) {
        children.push(child);
    }
    
    // rendering
    private function _cache() :Void {
//        trace("Caching "+children.length+" children");
        for( child in children ) {
            child._cache();
        }
        super._cache();
    }
    private function _render() :Void {
        GL.MultMatrixf( transform._v );
        for( i in 0...children.length ) {
            GL.PushName(i);
            children[i].render();
            GL.PopName();
        }
    }
}
