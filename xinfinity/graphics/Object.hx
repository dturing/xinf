package xinfinity.graphics;

class Object {

    public var transform:xinf.geom.Matrix;
    
    /* ------------------------------------------------------
       Properties and their Accessors
       ------------------------------------------------------ */

    public property x( _getX, _setX ):Float;
    public property y( _getY, _setY ):Float;
    public property width( _getWidth, _setWidth ):Float;
    public property height( _getHeight, _setHeight ):Float;
       
    private function _getX() : Float {
        return transform.tx;
    }
    private function _setX(x:Float) : Float {
        transform.tx = x;
        return x;
    }
    private function _getY() : Float {
        return transform.ty;
    }
    private function _setY(y:Float) : Float {
        transform.ty = y;
        return y;
    }
    private function _getWidth() : Float {
        return 0;
    }
    private function _setWidth(w:Float) : Float {
        return 0;
    }
    private function _getHeight() : Float {
        return 0;
    }
    private function _setHeight(h:Float) : Float {
        return 0;
    }
    
    /* ------------------------------------------------------
       Object API
       ------------------------------------------------------ */
    
    public function new() {
        transform = new xinf.geom.Matrix();
    }

    /* ------------------------------------------------------
       Rendering
       ------------------------------------------------------ */
    
    // cache the object as a displaylist, regard transform.
    private var _displayList:Int;
    private function _cache() :Void {
        if( _displayList == null ) {
            _displayList = GL.GenLists(1);
            GL.NewList( _displayList, GL.COMPILE );
            _render();
            GL.EndList();
        }
    }
    
    // children overwrite this to render their actual contents
    private function _render() :Void {
    }
    
    // children can overwrite this to render a simplified version used for hittest
    private function _render_simplet() :Void {
        // default
        _render();
    }
    
    // external interface (called from where?)
    public function render() :Void {
        GL.CallList( _displayList );
    }
}
