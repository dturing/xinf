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
		or query at [position] and [size]. It also maintains a list of children
		that you can manipulate with [attach()] and [detach()].
	</p>
	<p>
		You will often (maybe indirectly) derive from Object, and override the [drawContents()]
		method to draw something. Beware that you need to [destroy()] your Object's to free
		associated resources.
	</p>
**/

class Object extends SimpleEventDispatcher {
	private static var _manager:Manager;
	public static var manager(getManager,null):Manager;
	public static function getManager() :Manager {
		if( _manager == null ) {
			_manager = new Manager();
		}
		return _manager;
	}


	/** Unique (to the runtime environment) ID of this object. Will be set in the constructor. **/
	public var _id(default,null):Int;
	
	/** Other Object that contains this Object, if any. **/
	public var parent(default,null):Object;
	
	/** Current position of this Object in parent's coordinates.
		Set with moveTo(). **/
	public var position(default,null):{x:Float,y:Float};
	
	/** The Objects' size, in local's coordinates. 
		Set with resize().
		On XinfInity, the object's size defines it's area that is active
		to MOUSE_DOWN events. Other objects might use the size for
		layout or drawing. Size is here because it's convenient,
		it has no direct impact on Object's behaviour.
	**/
	public var size(default,null):{x:Float,y:Float};

	private var transform:Matrix;
	private var children:Array<Object>;
	

	/** Object constructor.<br/>
		A simple Object will not display anything by itself,
		but can be used as a container object to group other Objects.
	**/
	public function new() :Void {
		super();
		
		_id = Runtime.runtime.getNextId();
		manager.register( _id, this );
		
		transform = new Matrix().setIdentity();
		position = { x:0., y:0. };
		size = { x:0., y:0. };
		children = new Array<Object>();
		
		scheduleRedraw();
	}
	
	/** Object destructor.<br/>
		You must call this function if you want to get rid of this object and free
		all associated memory. (Yes, is garbage-collected, but we need some
		trigger to free all associated objects in the runtime. This is it.)
	**/
	public function destroy() :Void {
		// FIXME: we dont actually need the Manager's allObject list so much,
		// but what about deleting our associated Sprite/Div/GLObject?
		// also: detach from parent
		manager.unregister(_id);
	}
	
	/** attach (add) a child Object.<br/>
		Add 'child' to this object's list of children, inserts
		the child into the display hierarchy, similar to addChild in Flash 
		or appendChild in JavaScript/DOM.
		The new child will be added at the end of the list, so it will appear
		in front of all current children.
	**/
	public function attach( child:Object ) :Void {
		children.push( child );
		child.parent = this;
	// TODO: see Pane::resize	
		child.resize( child.size.x, child.size.y );
		scheduleRedraw();
	}

	/** detach (remove) a child Object<br/>
		Removes 'child' from this object's list of children. **/
	public function detach( child:Object ) :Void {
		children.remove( child );
		child.parent = null;
		scheduleRedraw();
	}

	public function moveTo( x:Float, y:Float ) :Void {
		position = { x:x, y:y };
		scheduleTransform();
	}

	public function resize( x:Float, y:Float ) :Void {
		size = { x:x, y:y };
		scheduleRedraw();
	}

	public function reTransform( g:Renderer ) :Void {
		transform.setTranslation( position.x, position.y );
		g.setTransform( _id, transform );
	}
	
	public function draw( g:Renderer ) :Void {
		g.startObject( _id );
			drawContents(g);
			
			// draw children
			for( child in children ) {
				g.showObject( child._id );
			}
			
		g.endObject();
		reTransform(g);
	}
	
	public function drawContents( g:Renderer ) :Void {
	}
	
	public function scheduleRedraw() :Void {
		manager.objectChanged( _id, this );
	}
	public function scheduleTransform() :Void {
		manager.objectMoved( _id, this );
	}
	
	public function globalToLocal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
		var q = { x:p.x, y:p.y };
		if( parent!=null ) q = parent.globalToLocal(q);
		q.x-=position.x;
		q.y-=position.y;
		return q;
	}
	public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
		var q = { x:p.x, y:p.y };
		q.x+=position.x;
		q.y+=position.y;
		if( parent!=null ) q = parent.localToGlobal(q);
		return q;
	}

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
