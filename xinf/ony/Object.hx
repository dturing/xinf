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

import xinf.erno.DrawingInstruction;
import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;

class Object extends SimpleEventDispatcher {
	private static var changedObjects:IntHash<Object> = new IntHash<Object>();
	public static function redrawChanged( g:Renderer ) :Void {
		var ch = changedObjects;
		changedObjects = new IntHash<Object>();
		var somethingChanged:Bool = false;
		for( id in ch.keys() ) {
			ch.get(id).draw( g );
			somethingChanged = true;
		}
		if( somethingChanged ) Runtime.runtime.changed();
	}
	private static var allObjects:IntHash<Object> = new IntHash<Object>();
	public static function findObjectById( id:Int ) :Object {
		return allObjects.get(id);
	}

	public static function drawAll( g:Renderer ) :Void {
		for( id in allObjects.keys() ) {
			allObjects.get(id).draw(g);
		}
	}

	public var _id:Int;
	private var children:Array<Object>;
	public var parent:Object;
	public var position(default,null):{x:Float,y:Float};
	public var size(default,null):{x:Float,y:Float};
	
	public function new() :Void {
		super();
		_id = Runtime.renderer.getNextId(); // FIXME: can this be done differently? clearer initialization of things?
		allObjects.set( _id, this );
		position = { x:0., y:0. };
		size = { x:0., y:0. };
		children = new Array<Object>();
		scheduleRedraw();
	}
	
	public function destroy() :Void {
		allObjects.remove(_id);
	}
	
	public function attach( child:Object ) :Void {
		children.push( child );
		child.parent = this;
	// TODO: WHY THIS?	child.resize( child.size.x, child.size.y );
		scheduleRedraw();
	}

	public function attachMany( c:Array<Object> ) :Void {
		children = children.concat( c );
	}

	public function detach( child:Object ) :Void {
		children.remove( child );
		child.parent = null;
		scheduleRedraw();
	}

	public function moveTo( x:Float, y:Float ) :Void {
		position = { x:x, y:y };
		scheduleRedraw();
	}

	public function resize( x:Float, y:Float ) :Void {
		size = { x:x, y:y };
		scheduleRedraw();
	}

	public function draw( g:Renderer ) :Void {
		g.draw( StartObject( _id ) );
			drawContents(g);
			
			// draw children
			for( child in children ) {
				g.draw( ShowObject( child._id ) );
			}
			
		g.draw( EndObject );
	}
	
	public function drawContents( g:Renderer ) :Void {
	}
	
	public function scheduleRedraw() :Void {
		changedObjects.set( _id, this );
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
