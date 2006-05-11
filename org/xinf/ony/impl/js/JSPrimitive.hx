package org.xinf.ony.impl.js;

import js.HtmlDom;
import org.xinf.event.Event;
import org.xinf.style.Style;
import org.xinf.style.Pad;
import org.xinf.style.Border;

class JSPrimitive implements org.xinf.ony.impl.IPrimitive {
    private var _e : HtmlDom;
    private var style : Style; // FIXME: use browser engine?

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
        untyped this.owner.dispatchEvent( new Event(Event.MOUSE_DOWN) );
    }
    public function _mouseUp() {
        untyped this.owner.dispatchEvent( new Event(Event.MOUSE_UP) );
    }
    public function _mouseOver() {
        untyped this.owner.dispatchEvent( new Event(Event.MOUSE_OVER) );
    }
    public function _mouseOut() {
        untyped this.owner.dispatchEvent( new Event(Event.MOUSE_OUT) );
    }
    

    public function new() :Void {
        _e = js.Lib.document.createElement("div");
        _e.style.position="absolute";
        js.Lib.document.getElementById("xinfony").appendChild( _e );
    }
    
    public function setOwner( owner:org.xinf.event.EventDispatcher ) :Void {
        untyped _e.owner = owner;
    }

    public function applyStyle( _style:org.xinf.style.Style ) :Void {
        style = _style;
        
        var padding:Pad = style.padding;
        var b:Float = style.border.thickness.px();
        _e.style.left = Math.floor( style.x.px() );
        _e.style.top  = Math.floor( style.y.px() );
        _e.style.width  = Math.floor( style.width.px() - (padding.left.px()+padding.right.px()+(b*2)) );
        _e.style.height = Math.floor( style.height.px() - (padding.top.px()+padding.bottom.px()+(b*2)) );
        _e.style.color = style.color.toString();
        _e.style.background = style.background.toString();
        _e.style.border = style.border.toString();
        _e.style.padding = style.padding.toString();
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
