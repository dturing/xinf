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

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Matrix;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;

/**
    A xinf.ony.Object is a basic Element in the xinfony display
    hierarchy.
    <p>
        An Object has a position and size that you can set with [moveTo()] and [resize()], 
        or query at [position] and [size].
    </p>
    <p>
        You will often (maybe indirectly) derive from Object, and override the [drawContents()]
        method to draw something. Beware that you need to [destroy()] your Object's to free
        associated resources.
    </p>
**/

class Object extends SimpleEventDispatcher {
    
    private static var _manager:Manager;
    private static var manager(getManager,null):Manager;
    
    private static function getManager() :Manager {
        if( _manager == null ) {
            _manager = new Manager();
        }
        return _manager;
    }

    public static function findById(id:Int) :Object {
        return( manager.find(id) );
    }


    /** Unique (to the runtime environment) ID of this object. Will be set in the constructor. **/
    public var _id(default,null):Int;
    
    /** Other Object that contains this Object, if any. **/
    public var parent:Container<Object>;
    
    /** Current position of this Object in parent's coordinates<br/>
        Set with [moveTo()]. **/
    public var position(default,null):{x:Float,y:Float};
    
    /** The Objects' size, in local's coordinates<br/>
        Set with [resize()].
        On XinfInity, the object's size defines it's area that is active
        to MOUSE_DOWN events. Other objects might use the size for
        layout or drawing. Size is here because it's convenient,
        it has no direct impact on Object's behaviour.
    **/
    public var size(default,null):{x:Float,y:Float};

    /** Object constructor<br/>
        A simple Object will not display anything by itself.
    **/
    public function new() :Void {
        super();
        
        _id = Runtime.runtime.getNextId();
        manager.register( _id, this );
        
        position = { x:0., y:0. };
        size = { x:0., y:0. };
        
        scheduleRedraw();
    }
    
    /** Object destructor<br/>
        You must call this function if you want to get rid of this object and free
        all associated memory. (Yes, is garbage-collected, but we need some
        trigger to free all associated objects in the runtime. This is it.)
    **/
    public function destroy() :Void {
        // how about deleting our associated Sprite/Div/GLObject?
        // also: detach from parent
        manager.unregister(_id);
    }

    /** move this Object to a new 2D position<br/>
        Schedules a [reTransform()]. Moving Objects should be pretty
        efficient on all runtimes. **/
    public function moveTo( x:Float, y:Float ) :Void {
        if( x!=position.x || y!=position.y ) {
            position = { x:x, y:y };
            scheduleTransform();
        }
    }

    /** resize this Object<br/>
        Sets new [size] and schedules a re-[draw()] of the Object.
        **/
    public function resize( x:Float, y:Float ) :Void {
        if( x!=size.x || y!=size.y ) {
            size = { x:x, y:y };
            scheduleRedraw();
        }
    }

    /** apply new transformation (position)<br/>
        This is an internal function, you should usually not care about it.
        **/
    public function reTransform( g:Renderer ) :Void {
        g.setTranslation( _id, position.x, position.y );
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [scheduleRedraw()] and 
        override [drawContents()] to draw stuff.
        **/
    public function draw( g:Renderer ) :Void {
        g.startObject( _id );
            drawContents(g);
        g.endObject();
        reTransform(g);
    }
    
    /** draw the Object's 'own' contents (not it's children) to the given [Renderer]<br/>
        You can override this method, and call the [Renderer]'s methods to draw things.
        Everything you do will be in the Object's local coordinate space.
        The default implementation does nothing, so it is safe to not call super.drawContents()
        (unless you are deriving from Object indirectly via some other Class that requires
        you to call it).
        **/
    public function drawContents( g:Renderer ) :Void {
    }

    /** schedule this Object for redrawing<br/>
        The Object will (on JavaScript: <i>should</i>) be redrawn before the next frame is shown to the user.
        Call this function whenever your Object needs to redraw itself because it's (immediate) content changed
        - there's no need to call it if anything changes about it's children. 
    **/
    public function scheduleRedraw() :Void {
        manager.objectChanged( _id, this );
    }
    
    /**    schedule this Object for redefining it's transformation<br/>
        You should usually not need to call this yourself, the Object will be automatically scheduled
        when you modify it's transformation (currently, the only way to do this is [moveTo()].
    **/
    public function scheduleTransform() :Void {
        manager.objectMoved( _id, this );
    }

    /** convert the given point from global to local coordinates<br/>
        FIXME: this function is currently implemented half-heartedly, and will
        only work for translation.
    **/
    public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        q.x-=position.x;
        q.y-=position.y;
        return q;
    }
    
    /** convert the given point from local to global coordinates<br/>
        FIXME: this function is currently implemented half-heartedly, and will
        only work for translation.
    **/
    public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        q.x+=position.x;
        q.y+=position.y;
        if( parent!=null ) q = parent.localToGlobal(q);
        return q;
    }
    
    /** dispatch the given Event<br/>
        tries to dispatch the given Event to any registered listeners.
        If no handler is found, 'bubble' the Event - i.e., pass it up to our parent.
    **/
    public function dispatchEvent<T>( e : Event<T> ) :Void {
        var l:List<Dynamic->Void> = listeners.get( e.type.toString() );
        var dispatched:Bool = false;
        if( l != null ) {
            for( h in l ) {
                h(e);
                dispatched=true;
            }
        }
        if( !dispatched && parent != null ) {
            parent.dispatchEvent(e);
        }
    }

    public function toString() :String {
        return( Type.getClassName( Type.getClass(this) )+"["+_id+"]" );
    }
    
}
