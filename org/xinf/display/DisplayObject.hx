package org.xinf.display;

import org.xinf.event.EventDispatcher;
import org.xinf.display.Stage;
import org.xinf.geom.Transform;
import org.xinf.render.IRenderer;

class DisplayObject extends EventDispatcher {
    private static var highestID:Int = 0;
    private var id:Int;
    private var _displayList:Int;
    private var _changed:Bool;

    public property name(default,default):String;
    
    public property parent(default,null):DisplayObjectContainer;
    public property root(default,null):DisplayObject;
    public property stage(default,null):Stage;
    
    public property transform(default,default):Transform;
    
    public property x( _get_x, _set_x ):Float;
    private function _get_x() : Float {
        return transform.matrix.tx;
    }
    private function _set_x( v:Float ) : Float {
        return transform.matrix.tx = v;
    }

    public property y( _get_y, _set_y ):Float;
    private function _get_y() : Float {
        return transform.matrix.ty;
    }
    private function _set_y( v:Float ) : Float {
        return transform.matrix.ty = v;
    }

    public property rotation( _get_rot, _set_rot ):Float;
    private function _get_rot() : Float {
        throw("get rotation NYI");
        return 0;
    }
    private function _set_rot( v:Float ) : Float {
        transform.matrix.setRotation(v);
        return v;
    }
    
    private function new() {
        super(null);
        transform = new Transform();
        id = highestID++;
        _displayList = null;
        _changed = true;
        name = "["+getSimpleClassname()+id+"]";
    }
    
    private function getSimpleClassname() {
        var n = Reflect.getClass(this).__name__;
        return( n[n.length-1] );
    }
    
    public function _render_cache( r:IRenderer ) {
        if( _changed ) {
            if( _displayList == null ) _displayList = r.genList();
            r.newList( _displayList );
            _render(r);
            r.endList();
            _changed = false;
        }
    }
    public function render( r:IRenderer ) {
        r.callList( _displayList );
    }
    private function _render( r:IRenderer ) {
    }
        
    private function asContainer() : DisplayObjectContainer {
        return null;
    }
    
    public function toString() {
        return( "<" + getSimpleClassname() + " " + name + ">" );
    }
}

