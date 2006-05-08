package xinfony;

import xinf.event.EventDispatcher;
import xinf.event.Event;
import xinfony.style.Style;
import xinfony.style.StyleChain;
import xinfony.style.Pad;
import xinfony.style.Border;

class Element extends EventDispatcher {
    public var name:String;
    public property style(get_style,set_style):Style;    
    private var _style:StyleChain;
    
    private var _e
        #if flash
            : flash.MovieClip
        #else js
            : js.HtmlDom
        #else neko
            : xinfinity.graphics.Object
        #end
        ;
        
    #if flash
        private static var eventNames:Hash<String> = registerEventNames();
        private static function registerEventNames() : Hash<String> {
            var h:Hash<String> = new Hash<String>();
            h.set( Event.MOUSE_DOWN,"onPress");
            h.set( Event.MOUSE_UP,  "onRelease");
            h.set( Event.MOUSE_OVER,"onRollOver");
            h.set( Event.MOUSE_OUT, "onRollOut");
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
        _style = StyleChain.DEFAULT.clone();
        
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
            xinfinity.graphics.Root.root.addChild( _e );
        #end
        untyped _e.owner = this;
        
        styleChanged();
    }

    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Group();
    }
    #end

    public function addEventListener( type:String, f:Event->Bool ) :Void {
        #if flash
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                Reflect.setField( _e, eventName, Reflect.field( this, "_"+type ) );
            }
        #else js
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                Reflect.setField( _e, eventName, Reflect.field( this, "_"+type ) );
            }
        #end
        super.addEventListener( type, f );
    }
    
    public function set_style( style:Style ) :Style {
        _style.popStyle();
        _style.pushStyle( style );
        styleChanged();
        return _style;
    }
    public function get_style() :Style {
        return _style;
    }
    
    public function styleChanged() :Void {
        #if flash
            _e._x = _style.x.px();
            _e._y = _style.y.px();
        #else js
            var padding:Pad = _style.padding;
            var b:Float = _style.border.thickness.px();
            _e.style.left = Math.floor( style.x.px() );
            _e.style.top  = Math.floor( style.y.px() );
            _e.style.width  = Math.floor( _style.width.px() - (padding.left.px()+padding.right.px()+(2*b)-1) );
            _e.style.height = Math.floor( _style.height.px() - (padding.top.px()+padding.bottom.px()+(2*b)-1) );
            _e.style.color = _style.color.toString();
            _e.style.background = _style.background.toString();
            _e.style.border = _style.border.toString();
            _e.style.padding = _style.padding.toString();
            _e.style.margin = _style.margin.toString();
        #else neko
            _e.style = _style;
            _e.changed();
        #end
    }
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + ">" );
    }
}
