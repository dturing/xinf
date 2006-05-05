package xinfony;

import xinf.event.EventDispatcher;
import xinf.event.Event;

class Element extends EventDispatcher {
    public var name:String;
    
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
        
    public function new( _name:String ) {
        name = _name;
        
        super();
        
        // create the runtime-specific proxy element
        #if flash
            _e = flash.Lib._root.createEmptyMovieClip(name,flash.Lib._root.getNextHighestDepth());
        #else js
            _e = js.Lib.document.createElement("div");
            _e.style.position="absolute";
            js.Lib.document.getElementById("xinfony").appendChild( _e );
        #else neko
            _e = createPrimitive();
            xinfinity.graphics.Root.root.appendChild( _e );
        #end
    }

    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Group();
    }
    #end

    public function addEventListener( type:String, f:Event->Bool ) :Void {
        #if flash
            var self = this;
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                Reflect.setField( _e, eventName, function() {
                        self.handleFlashEvent( type );
                    } );
            }
        #else js
            var self = this;
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                Reflect.setField( _e, eventName, function() {
                        self.handleJSEvent( type);
                    } );
            }
        #end
        super.addEventListener( type, f );
    }

    #if flash
    public function handleFlashEvent( type:String ) {
        // TODO: fill Event Structure from flash data
        dispatchEvent( new Event(type) );
    }
    #else js
    public function handleJSEvent( type:String ) {
        // TODO: fill Event Structure from js data
        dispatchEvent( new Event(type) );
    }
    #end    
    
    
    public function move( x:Float, y:Float ) {
        #if flash
            _e._x = x;
            _e._y = y;
        #else js
            _e.style.left = Math.round(x);
            _e.style.top = Math.round(y);
        #else neko
            _e.x = x;
            _e.y = y;
        #end
    }
}
