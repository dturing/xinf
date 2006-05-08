package xinfinity.graphics;

import xinf.event.EventDispatcher;
import xinf.event.Event;

// TODO: if this remains the only reference to xinfony, 
// style stuff should probably be move to xinf.style
import xinfony.style.Style;

class Object {
    public static var DEFAULT_STYLE = new Style("background: #fff; color: #000; border: none; padding: 1px; margin: 0px;");

    private var _displayList:Int;
    private var _displayListSimple:Int;
    private var _changed:Bool;
    
    public var transform:xinf.geom.Matrix;
    public var owner:EventDispatcher;
    public var style:Style;
    
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
        _displayList = _displayListSimple = null;
        style = DEFAULT_STYLE;
        changed();
    }
    
    public function changed() {
        _changed = true;
        changedObjects.push(this);
    }
    
    private static var changedObjects:Array<Object> = new Array<Object>();
    public static function cacheChanged() {
        var o:Object;
        while( (o=changedObjects.shift()) != null ) {
            o._cache();
        }
    }

    public function dispatchEvent( e:Event ) {
        if( owner == null ) throw("Object "+this+" has no owner.");
        owner.dispatchEvent(e);
    }

    /* ------------------------------------------------------
       Rendering
       ------------------------------------------------------ */
    
    // cache the object as a displaylist, regard transform.
    public function _cache() :Void {
        if( _changed ) {
            if( _displayList == null ) {
                _displayList = GL.GenLists(1);
            }
            GL.NewList( _displayList, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _render();
            GL.PopMatrix();
            GL.EndList();
            
            // cache simplified (maybe not do this if they are the same?)
            if( _displayListSimple == null ) {
                _displayListSimple = GL.GenLists(1);
            }
            GL.NewList( _displayListSimple, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _renderSimple();
            GL.PopMatrix();
            GL.EndList();
            
            _changed = false;
        }
    }
    
    // children overwrite this to render their actual contents
    private function _render() :Void {
    }
    
    // children can overwrite this to render a simplified version used for hittest
    private function _renderSimple() :Void {
        // default
        _render();
    }
    
    // external interface (called from where?)
    public function render() :Void {
        GL.CallList( _displayList );
    }
    public function renderSimple() :Void {
        GL.CallList( _displayListSimple );
    }
    
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + " #" + _displayList + ">" );
    }
}
