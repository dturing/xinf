/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package org.xinf.ony;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;
import org.xinf.geom.Point;

#if neko
    import org.xinf.inity.Group;
#else js
    import js.Dom;
#end

/**
    Element is the basic graphical primitive of the xinfony API. All other visible elements derive from it.
    
    The implementation of Element depends on the runtime: in Flash, it's a MovieClip; in JavaScript it's a DIV element,
    and for xinfinity it's a Group.
**/

class Element extends EventDispatcher {
    /**
        The name of the element, usually only needed for identification and debugging.
    **/
    public var name:String;
    
    /**
        The bounding rectangle of the element. You can manipulate it to move and resize the element.
        Specific subclasses might automatically set the bounds or react in certain ways to changes.
    **/
    public var bounds:Bounds;

    private var parent:Element;
    private var children:Array<Element>;
    private var _p
        #if neko
            :Group
        #else js
            :js.HtmlDom
        #else flash
            :flash.MovieClip
        #end
        ;
    
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
        private function _mouseDown( e:js.Event ) :Bool {
            mouseEvent( Event.MOUSE_DOWN, e, untyped this );
            return false;
        }
        private function _mouseUp( e:js.Event ) {
            mouseEvent( Event.MOUSE_UP, e, untyped this );
        }
        private function _mouseOver( e:js.Event ) {
            mouseEvent( Event.MOUSE_OVER, e, untyped this );
        }
        private function _mouseOut( e:js.Event ) {
            mouseEvent( Event.MOUSE_OUT, e, untyped this );
        }
        private static function absPos( div:js.HtmlDom ) :Point {
            var r=new Point( untyped div.offsetLeft, untyped div.offsetTop );
            while( div.parentNode != null && div.parentNode.nodeName == "DIV" ) {
                div = div.parentNode;
                r.x += untyped div.offsetLeft;
                r.y += untyped div.offsetTop;
            }
            return r;
        }
        private static function mouseEvent( type:String, e:js.Event, target:js.HtmlDom ) :Void {
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
        private function _mouseDown() {
            untyped this.owner.postEvent( Event.MOUSE_DOWN, { x:this._xmouse, y:this._ymouse } );
        }
        private function _mouseUp() {
            untyped this.owner.postEvent( Event.MOUSE_UP, { x:this._xmouse, y:this._ymouse } );
        }
        private function _mouseOver() {
            untyped this.owner.postEvent( Event.MOUSE_OVER, { x:this._xmouse, y:this._ymouse } );
        }
        private function _mouseOut() {
            untyped this.owner.postEvent( Event.MOUSE_OUT, { x:this._xmouse, y:this._ymouse } );
        }
    #end

    /**
        Element constructor. You have to supply a name and a parent Element, to which the new Element
        will be attached to. Currently, xinfony Elements can not be re-parented, because Flash<9 does not
        support that functionality.
    **/
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

        bounds.addEventListener( Event.POSITION_CHANGED, onPositionChanged );
        bounds.addEventListener( Event.SIZE_CHANGED, onSizeChanged );
        
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
    

    /**
        Add a new listener function for a specific event. See the EventDispatcher class for details.
        Adding listeners for mouse events will setup the needed handlers on the runtime primitive.
    **/
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
    

    /**
        Dispatch an Event to the Element. See the EventDispatcher class for details.
        Element will dispatch the Event to it's parent if it is not stopped.
    **/
    public function dispatchEvent( e:Event ) :Void {
        super.dispatchEvent( e );
        
        // propagate to parent
        if( !e.stopped && parent != null ) {
            parent.dispatchEvent(e);
        }
    }


    private function onPositionChanged( e:Event ) :Void {
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

    private function onSizeChanged( e:Event ) :Void {
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
        private function scheduleRedraw() :Void {
            // FIXME: for now, just redraw. can prolly save a lot to buffer these and process after events!
            redraw();
        }

        private function redraw() :Void {
        }
    #end
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + " " + name + ">" );
    }
}
