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
    private var _width:Float;
    private var _height:Float;
    private function _getWidth() : Float {
        return _width;
    }
    private function _setWidth(w:Float) : Float {
        _width=w; return w;
    }
    private function _getHeight() : Float {
        return _height;
    }
    private function _setHeight(h:Float) : Float {
        _height = h; return h;
    }
    
    /* ------------------------------------------------------
       Object API
       ------------------------------------------------------ */
    
    public function new() {
        transform = new xinf.geom.Matrix();
        width = height = .0;
    }

    /* ------------------------------------------------------
       Rendering
       ------------------------------------------------------ */
    
    // cache the object as a displaylist, regard transform.
    private var _displayList:Int;
    private function _cache() :Void {
        if( _displayList == null ) {
            _displayList = GL.GenLists(1);
        }
        GL.NewList( _displayList, GL.COMPILE );
        GL.PushMatrix();
            GL.MultMatrixf( transform._v );
            _render();
        GL.PopMatrix();
        GL.EndList();
    }
    
    // children overwrite this to render their actual contents
    private function _render() :Void {
    }
    
    // children can overwrite this to render a simplified version used for hittest
    private function _render_simple() :Void {
        // default
        _render();
    }
    
    // external interface (called from where?)
    public function render() :Void {
        GL.CallList( _displayList );
    }
    
    
    public function toString() :String {
        return( "["+ Reflect.getClass(this).__name__.join(".") + "]" );
    }
}
