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

package xinf.ony;

import xinf.event.EventDispatcher;
import xinf.event.Event;
import xinf.geom.Point;

#if neko
    import xinf.inity.Group;
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
    
    public var autoSize( default, default ) :Bool;
    public var visible( get_visible, set_visible ) :Bool;

    /**
        The bounding rectangle of the element. You can manipulate it to move and resize the element.
        Specific subclasses might automatically set the bounds or react in certain ways to changes.
    **/
    public var bounds:Bounds;

    private var parent:Element;
    private var _p:Primitive;
    
    /**
        Element constructor. You have to supply a name and a parent Element, to which the new Element
        will be attached to. Currently, xinfony Elements can not be re-parented, because Flash<9 does not
        support that functionality.
    **/
    public function new( _name:String, _parent:Element ) :Void {
        name = _name;
        parent = _parent;
        bounds = new Bounds();
        autoSize = false;
        
        _p = createPrimitive();
        
        #if neko
            _p.owner = this;
            _p.bounds = bounds; // FIXME needed? do the change listening in inity.Object?
            if( parent != null ) {
                parent._p.addChild( _p );
                parent._p.changed(); // FIXME needed?
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

    private function createPrimitive() :Primitive {
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

    // TODO: destroy element
    public function destroy() :Void {
        // TODO: keep track of children, to destroy, too?        
        #if neko
            _p.owner = null;
            _p.parent.removeChild( _p );
            _p = null;
        #else js
            untyped _p.owner = null;
            parent._p.removeChild( _p );
            _p = null;
        #else flash
            untyped _p.owner = null;
            _p.removeMovieClip();
            _p = null;
        #end
    }

    /**
        Dispatch an Event to the Element. See the EventDispatcher class for details.
        Element will dispatch the Event to it's parent.
    **/
    override public function dispatchEvent( e:Event ) :Void {
		if( _p == null ) return;
		
        super.dispatchEvent( e );
        
        // propagate to parent
        if( parent != null ) 
            parent.dispatchEvent(e);
        else
            xinf.event.EventDispatcher.global.dispatchEvent( e );
    }


    private function onPositionChanged( e:Event ) :Void {
            if( _p == null ) throw("no _p for onPositionChanged "+this);
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
            if( _p == null ) throw("no _p for onSizeChanged "+this);
        #if neko
            _p.changed();
        #else js
            if( !autoSize ) {
                _p.style.width  = Math.floor( e.data.width );
                _p.style.height = Math.floor( e.data.height );
            }
        #else flash
            scheduleRedraw();
        #end
    }

    /**
        Convert a point in global coordinate space to local coordinates.
        Note that "global coordinate space" means the one of Root.
    **/
    public function globalToLocal( p:xinf.geom.Point ) :xinf.geom.Point {
        var q = new xinf.geom.Point( p.x, p.y );
        var parent:Element = this;
        while( parent != null ) {
            q.x -= parent.bounds.x;
            q.y -= parent.bounds.y;
            parent = parent.parent;
        }
        return q;
    }

    /**
        Convert a point in local coordinate space to global coordinates.
        Note that "global coordinate space" means the one of Root.
    **/
    public function localToGlobal( p:xinf.geom.Point ) :xinf.geom.Point {
        var q = new xinf.geom.Point( p.x, p.y );
        var parent:Element = this;
        while( parent != null ) {
            q.x += parent.bounds.x;
            q.y += parent.bounds.y;
            parent = parent.parent;
        }
        return q;
    }
    
    private function get_visible():Bool {
        #if flash
            return( _p._visible );
        #else js
            if( _p.style.visibility == "hidden" )
                return false;
            return true;
        #else neko
            return( _p.visible );
        #end
    }
    private function set_visible(v:Bool):Bool {
        #if flash
            return( _p._visible=v );
        #else js
            if( v ) {
                _p.style.visibility="visible";
            } else {
                _p.style.visibility="hidden";
            }
            return v;
        #else neko
            _p.visible = v;
            _p.changed();
            return( v );
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
