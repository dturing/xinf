package org.xinf.ony.impl.js;

import js.HtmlDom;
import org.xinf.event.Event;
import org.xinf.style.Style;
import org.xinf.ony.impl.IPrimitive;

class JSPrimitive implements org.xinf.ony.impl.IPrimitive {
    private var _e : HtmlDom;

    private static var eventNames:Hash<String> = registerEventNames();
    private static function registerEventNames() : Hash<String> {
        var h:Hash<String> = new Hash<String>();
        h.set( Event.MOUSE_DOWN,"onmousedown");
        h.set( Event.MOUSE_UP,  "onmouseup");
        h.set( Event.MOUSE_OVER,"onmouseover");
        h.set( Event.MOUSE_OUT, "onmouseout");
        return h;
    }

    // event wrappers: "this" is the runtime primitive.
    public function _mouseDown() {
        untyped this.owner.postEvent( Event.MOUSE_DOWN );
    }
    public function _mouseUp() {
        untyped this.owner.postEvent( Event.MOUSE_UP );
    }
    public function _mouseOver() {
        untyped this.owner.postEvent( Event.MOUSE_OVER );
    }
    public function _mouseOut() {
        untyped this.owner.postEvent( Event.MOUSE_OUT );
    }
    

    public function new() :Void {
        _e = js.Lib.document.createElement("div");
        _e.style.position="absolute";
        js.Lib.document.getElementById("xinfony").appendChild( _e ); // FIXME: XXX
    }
    
    public function setOwner( owner:org.xinf.event.EventDispatcher ) :Void {
        untyped _e.owner = owner;
    }

    public function addChild( child:IPrimitive ) :Void {
        var p:JSPrimitive = cast(child,JSPrimitive);
        _e.appendChild( p._e );
    }
    
    public function removeChild( child:IPrimitive ) :Void {
        var p:JSPrimitive = cast(child,JSPrimitive);
        _e.removeChild( p._e );
    }

    public function applyBounds( bounds:org.xinf.ony.Bounds ) :Void {
        trace("Set JS Bounds: "+bounds );
        _e.style.left = Math.floor( bounds.x );
        _e.style.top  = Math.floor( bounds.y );
//        _e.style.width  = Math.floor( bounds.height );
//        _e.style.height = Math.floor( bounds.width );
    }
    public function applyStyle( _style:org.xinf.style.Style ) :Void {
        var cl = "";
        for( k in untyped _e.owner.getStyleClasses() ) {
            cl += k+" ";
        }
        untyped _e.className = cl;
    }

    public function eventRegistered( type:String ) :Void {
        var eventName:String = eventNames.get(type);
        if( eventName != null ) {
            for( name in eventName.split(",") ) {
                Reflect.setField( _e, name, Reflect.field( this, "_"+type ) );
            }
        }
    }
}
