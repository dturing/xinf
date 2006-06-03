package org.xinf.ony;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;
import org.xinf.geom.Point;

#if neko
    import org.xinf.inity.Group;
#end

class Element extends EventDispatcher {
    public var name:String;
    public var parent:Element;
    public var bounds:Bounds;
    
    private var _p
        #if neko
            :Group
        #else js
            :js.HtmlDom
        #else flash
            :flash.MovieClip
        #end
        ;
    private var children:Array<Element>;
    
    #if js
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
        public function _mouseDown( e:js.Event ) :Bool {
            mouseEvent( Event.MOUSE_DOWN, e, untyped this );
            return false;
        }
        public function _mouseUp( e:js.Event ) {
            mouseEvent( Event.MOUSE_UP, e, untyped this );
        }
        public function _mouseOver( e:js.Event ) {
            mouseEvent( Event.MOUSE_OVER, e, untyped this );
        }
        public function _mouseOut( e:js.Event ) {
            mouseEvent( Event.MOUSE_OUT, e, untyped this );
        }
        public static function absPos( div:js.HtmlDom ) :Point {
            var r=new Point( untyped div.offsetLeft, untyped div.offsetTop );
            while( div.parentNode != null && div.parentNode.nodeName == "DIV" ) {
                div = div.parentNode;
                r.x += untyped div.offsetLeft;
                r.y += untyped div.offsetTop;
            }
            return r;
        }
        public static function mouseEvent( type:String, e:js.Event, target:js.HtmlDom ) :Void {
            var abs:Point = absPos(target);
            var p:Point = new Point( e.clientX, e.clientY );
            p = p.subtract(abs);
            untyped target.owner.postEvent( type, { x:p.x, y:p.y } );
        }
    #else flash
        private static var eventNames:Hash<String> = registerEventNames();
        private static function registerEventNames() : Hash<String> {
            var h:Hash<String> = new Hash<String>();
            h.set( Event.MOUSE_DOWN,"onPress");
            h.set( Event.MOUSE_UP,  "onRelease");
            h.set( Event.MOUSE_OVER,"onRollOver,onDragOver");
            h.set( Event.MOUSE_OUT, "onRollOut,onDragOut");
            return h;
        }

        // event wrappers: "this" is the runtime primitive.
        public function _mouseDown() {
            untyped this.owner.postEvent( Event.MOUSE_DOWN, { x:this._xmouse, y:this._ymouse } );
        }
        public function _mouseUp() {
            untyped this.owner.postEvent( Event.MOUSE_UP, { x:this._xmouse, y:this._ymouse } );
        }
        public function _mouseOver() {
            untyped this.owner.postEvent( Event.MOUSE_OVER, { x:this._xmouse, y:this._ymouse } );
        }
        public function _mouseOut() {
            untyped this.owner.postEvent( Event.MOUSE_OUT, { x:this._xmouse, y:this._ymouse } );
        }
    #end

    public function new( _name:String, _parent:Element ) :Void {
        name = _name;
        parent = _parent;
        bounds = new Bounds();
        
        children = new Array<Element>();
        _p = createPrimitive();
        
        #if neko
            _p.owner = this;
            _p.bounds = bounds; // FIXME needed? do the change listening in inity.Object?
            if( parent != null ) {
                parent._p.addChild( _p );
                parent._p.changed();
            }
        #else js
            untyped _p.owner = this;
            if( parent != null ) parent._p.appendChild( _p );
            _p.style.position="absolute";
        #else flash
            untyped _p.owner = this;
        #end

        bounds.addEventListener("positionChanged", onPositionChanged );
        bounds.addEventListener("sizeChanged", onSizeChanged );
        
        super();
     }

    private function createPrimitive() :Dynamic {
        #if js
            return js.Lib.document.createElement("div");
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
        #else neko
            throw("dont know which Primitive to create for "+this);
            return null;
        #end
    }
    
    public function dispatchEvent( e:Event ) :Void {
        super.dispatchEvent( e );
        
        // propagate to parent
        if( !e.stopped && parent != null ) {
            parent.dispatchEvent(e);
        }
    }

    public function addEventListener( type:String, f:Event->Void ) :Void {
        #if js
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                for( name in eventName.split(",") ) {
                    Reflect.setField( _p, name, Reflect.field( this, "_"+type ) );
                }
            }
        #else flash
            var eventName:String = eventNames.get(type);
            if( eventName != null ) {
                for( name in eventName.split(",") ) {
                    Reflect.setField( _p, name, Reflect.field( this, "_"+type ) );
                }
            }
        #end
        super.addEventListener( type, f );
    }
    
    public function onPositionChanged( e:Event ) :Void {
        #if neko
            _p.changed();
        #else js
            _p.style.left = Math.floor( e.data.x );
            _p.style.top  = Math.floor( e.data.y );
        #else flash
            _p._x = e.data.x;
            _p._y = e.data.y;
        #end
    }

    public function onSizeChanged( e:Event ) :Void {
        #if neko
            _p.changed();
        #else js
            _p.style.width  = Math.floor( e.data.width );
            _p.style.height = Math.floor( e.data.height );
        #else flash
            scheduleRedraw();
        #end
    }
    
    #if flash
        public function scheduleRedraw() :Void {
            // FIXME: for now, just redraw. can prolly save a lot to buffer these and process after events!
            redraw();
        }

        public function redraw() :Void {
        }
    #end
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + " " + name + ">" );
    }
}
