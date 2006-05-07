package xinfinity.graphics;

class Group extends Object {
    private var children:Array<Object>;
    
    public function new() {
        super();
        children = new Array<Object>();
    }

    public function addChild( child:Object ) {
        children.push(child);
    }
    
    public function getChildAt( index:Int ) : Object {
        return children[index];
    }
    
    // rendering
    private function _cache() :Void {
        for( child in children ) {
            child._cache();
        }
        super._cache();
    }
    private function _render() :Void {
        for( child in children ) {
            child.render();
        }
    }
    private function _renderSimple() :Void {
        for( i in 0...children.length ) {
            GL.PushName(i);
            children[i].renderSimple();
            GL.PopName();
        }
    }
}
