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

package xinf.erno;

import xinf.erno.PenStackRenderer;
import xinf.erno.Renderer;
import xinf.geom.Transform;

class ObjectModelRenderer<Primitive> extends PenStackRenderer {
	
	private var objects:IntHash<Primitive>;
	
	private function lookup( id:Int ) :Primitive {
		return objects.get(id);
	}
	
	private var current:Primitive;

	/* API to override */
	public function createPrimitive(id:Int) :Primitive {
		return null;
	}
	
	public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
	}
	
	public function clearPrimitive( p:Primitive ) :Void {
	}
	
	public function setPrimitiveTransform( p:Primitive, t:Transform ) :Void {
	}
	
	public function getDefaultRoot() :Primitive {
		return null;
	}

	/* public API */
	public function new() :Void {
		super();
		objects = new IntHash<Primitive>();
		objects.set(0,current);
	}

	// we implement the root and object parts of the erno Instruction protocol
	public function startNative( o:NativeContainer ) :Void {
		// TODO #if debug, check if current is set

		// FIXME cast unneccessary if type parameter (Primitive) was constrained to NativeContainer
		// causes problem in haxe: "Should implement by using an interface or a class". 
		// see ml 2006-12-13. (fixed on cvs)
		current=cast(o);
		pushPen();
	}
	
	public function endNative() :Void {
		current=null;
	}

	public function startObject( id:Int ) {
		// TODO #if debug, check if current is set
		// see if there already is an object with that id.
		current = lookup(id);
		if( current == null ) {
			// create new object
			current = createPrimitive(id);
			objects.set(id,current);
		} else {
			// clear object
			clearPrimitive( current );
		}
		pushPen();
	}
	
	public function endObject() {
		current = null;
		popPen();
	}
	
	public function showObject( id:Int ) {
		var o = lookup(id);
		if( o==null ) {
			o = createPrimitive(id);
			objects.set(id,o);
		}
		attachPrimitive( current, o );
	}
	
	public function setTransform( id:Int, transform:Transform ) {
		var o = lookup(id);
		if( o==null ) {
			o = createPrimitive(id);
			objects.set(id,o);
		}
		setPrimitiveTransform( o, transform );
	}
	
}
