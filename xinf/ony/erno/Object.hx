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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Matrix;
import xinf.geom.Transform;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;
import xinf.style.StyleParser;

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

class Object extends SimpleEventDispatcher, implements xinf.ony.Element {
    
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


    public var xid(default,null):Int;
    public var id(default,null):String;
    public var parent(default,null):xinf.ony.Group;
    public var document(default,null):xinf.ony.Document;
    public var style(default,null):xinf.style.ElementStyle;
    
    public var transform(default,set_transform):Transform;
    private function set_transform( t:Transform ) :Transform {
        transform=t;
        scheduleTransform();
        return transform;
    }
    
    /** Object constructor<br/>
        A simple Object will not display anything by itself.
    **/
    public function new() :Void {
        super();
        
        xid = Runtime.runtime.getNextId();
        manager.register( xid, this );
        transform = new Identity();
        style = new xinf.style.ElementStyle(this);
        
        scheduleRedraw();
    }
    
    /** Object destructor<br/>
        You must call this function if you want to get rid of this object and free
        all associated memory. (Yes, is garbage-collected, but we need some
        trigger to free all associated objects in the runtime. This is it.)
        
        Could this be done on deattach? we dont need it registered any more...
    **/
    public function destroy() :Void {
        // how about deleting our associated Sprite/Div/GLObject?
        // also: detach from parent
        manager.unregister(xid);
    }

    /** apply new transformation (position)<br/>
        This is an internal function, you should usually not care about it.
        **/
    public function reTransform( g:Renderer ) :Void {
        var m = transform.getMatrix();
        g.setTransform( xid, m.tx, m.ty, m.a, m.b, m.c, m.d );
        // TODO g.setTranslation( xid, position.x, position.y );
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [scheduleRedraw()] and 
        override [drawContents()] to draw stuff.
        **/
    public function draw( g:Renderer ) :Void {
        g.startObject( xid );
            drawContents(g);
        g.endObject();
        reTransform(g);
    }
    
    /** draw the Object's 'own' contents (not it's children) to the given [Renderer]<br/>
        You can override this method, and call the [Renderer]'s methods to draw things.
        Everything you do will be in the Object's local coordinate space.
        **/
    public function drawContents( g:Renderer ) :Void {
        var c = style.fill;
        if( c!=null ) g.setFill( c.r, c.g, c.b, c.a );
        else g.setFill( 0,0,0,1 );

        c = style.stroke;
        var w = style.strokeWidth;
        if( w==null ) w=1.;
        if( c!=null ) {
            #if neko
                w = localToGlobal( {x:w,y:0.} ).x;
            #end
            g.setStroke( c.r,c.g,c.b,c.a,w );
        } else {
            g.setStroke( 0,0,0,0,0 );
        }
    }

    /** schedule this Object for redrawing<br/>
        The Object will (on JavaScript: <i>should</i>) be redrawn before the next frame is shown to the user.
        Call this function whenever your Object needs to redraw itself because it's (immediate) content changed
        - there's no need to call it if anything changes about it's children. 
    **/
    public function scheduleRedraw() :Void {
        manager.objectChanged( xid, this );
    }
    
    /**    schedule this Object for redefining it's transformation<br/>
        You should usually not need to call this yourself, the Object will be automatically scheduled
        when you modify it's transformation (currently, the only way to do this is [moveTo()].
    **/
    public function scheduleTransform() :Void {
        manager.objectMoved( xid, this );
    }

    /** convert the given point from global to local coordinates **/
    public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        return( transform.applyInverse(q) );
    }
    
    public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.localToGlobal(q);
        return( transform.apply(q) );
    }
    
    public function attachedTo( p:xinf.ony.Group ) {
        parent=p;
        document=parent.document;
        styleChanged();
    }

    public function detachedFrom( p:xinf.ony.Group ) {
        parent=null;
        document=null;
    }

    public function fromXml( xml:Xml ) :Void {
        if( xml.exists("id") ) {
            id = xml.get("id");
        }
        if( xml.exists("style") ) {
            style.parse( xml.get("style") );
        }
        style.fromXml( xml );
        
        if( xml.exists("transform") ) {
            transform = TransformParser.parse( xml.get("transform") );
        }
    }

    public function styleChanged() :Void {
    }

    /** dispatch the given Event<br/>
        tries to dispatch the given Event to any registered listeners.
        If no handler is found, 'bubble' the Event - i.e., pass it up to our parent.
    **/
    override public function dispatchEvent<T>( e : Event<T> ) :Void {
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
        return( Type.getClassName( Type.getClass(this) )+"["+xid+"]" );
    }
    
    
    /* SVG parsing helper function-- should go somewhere else? FIXME */
    function getFloatProperty( xml:Xml, name:String, ?def:Float ) :Float {
        if( xml.exists(name) ) return Std.parseFloat(xml.get(name));
        if( def==null ) def=0;
        return def;
    }

    function getBooleanProperty( xml:Xml, name:String, ?def:Bool ) :Bool {
        if( xml.exists(name) ) {
            var v = xml.get(name);
            if( v.toLowerCase()=="true" || v=="1" ) return true;
            return false;
        }
        if( def==null ) def=false;
        return def;
    }
    
}
