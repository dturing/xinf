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

    public function setBounds( bounds:org.xinf.ony.Bounds ) :Void {
        bounds.addEventListener( "positionChanged", onPositionChanged );
        bounds.addEventListener( "sizeChanged", onSizeChanged );
    }
    
    public function onPositionChanged( e:Event ) {
        _e.style.left = Math.floor( e.data.x );
        _e.style.top  = Math.floor( e.data.y );
    }
    
    public function onSizeChanged( e:Event ) {
   //     _e.style.width  = Math.floor( e.data.width );
   //     _e.style.height = Math.floor( e.data.height );
    }
    
    public function setStyle( _style:org.xinf.style.Style ) :Void {
        _style.addEventListener( "changed", onStyleChanged );
    }
    public function onStyleChanged( e:Event ) :Void {
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
