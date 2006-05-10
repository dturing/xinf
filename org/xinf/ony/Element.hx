package org.xinf.ony;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

class Element extends EventDispatcher {
    public var name:String;
    
    private var _e
        #if flash
            : flash.MovieClip
        #else js
            : js.HtmlDom
        #else neko
            : org.xinf.inity.Object
        #end
        ;
        
    #if flash
        private static var eventNames:Hash<String> = registerEventNames();
        private static function registerEventNames() : Hash<String> {
            var h:Hash<String> = new Hash<String>();
            h.set( Event.MOUSE_DOWN,"onPress");
            h.set( Event.MOUSE_UP,  "onRelease");
            h.set( Event.MOUSE_OVER,"onRollOver,onDragOver");
            h.set( Event.MOUSE_OUT, "onRollOut,onDragOut");
            return h;
        }
    #else js
        private static var eventNames:Hash<String> = registerEventNames();
        private static function registerEventNames() : Hash<String> {
            var h:Hash<String> = new Hash<String>();
            h.set( Event.MOUSE_DOWN,"onmousedown");
            h.set( Event.MOUSE_UP,  "onmouseup");
            h.set( Event.MOUSE_OVER,"onmouseover");
            h.set( Event.MOUSE_OUT, "onmouseout");
            return h;
        }
    #end

    // event wrappers for js and flash: "this" is the runtime primitive.
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
        
        
    public function new( _name:String ) {
        name = _name;
        
        super();
        
        // create the runtime-specific primitive
        #if flash
            _e = flash.Lib._root.createEmptyMovieClip(name,flash.Lib._root.getNextHighestDepth());
        #else js
            _e = js.Lib.document.createElement("div");
            _e.style.position="absolute";
            js.Lib.document.getElementById("xinfony").appendChild( _e );
        #else neko
            _e = createPrimitive();
            org.xinf.inity.Root.root.addChild( _e );
        #end
        untyped _e.owner = this;
    }

    #if neko
    private function createPrimitive() : org.xinf.inity.Object {
        return new org.xinf.inity.Group();
    }
    #end

    public function addEventListener( type:String, f:Event->Bool ) :Void {
        #if flash
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                for( name in eventName.split(",") ) {
                    Reflect.setField( _e, name, Reflect.field( this, "_"+type ) );
                }
            }
        #else js
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                Reflect.setField( _e, eventName, Reflect.field( this, "_"+type ) );
            }
        #end
        super.addEventListener( type, f );
    }
    
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + ">" );
    }
}
