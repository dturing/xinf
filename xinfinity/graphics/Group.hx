package xinfinity.graphics;

class Group extends Object {
    private var children:Array<Object>;
    
    public function appendChild( child:Object ) {
        children.push(child);
    }
    
    // rendering
    private function _cache() :Void {
        for( child in children ) {
            child._cache();
        }
        super._cache();
    }
    private function _render() :Void {
        super._render();
        for( i in 0...children.length ) {
            GL.PushName(i);
            children[i].render();
            GL.PopName();
        }
    }
}
