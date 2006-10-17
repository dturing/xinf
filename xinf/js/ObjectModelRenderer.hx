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

package xinf.js;

import xinf.erno.PenStackRenderer;
import xinf.erno.DrawingInstruction;

class ObjectModelRenderer<Primitive> extends PenStackRenderer {
	
	private var objects:IntHash<Primitive>;
	private function lookup( id:Int ) :Primitive {
		return objects.get(id);
	}
	
	private var current:Primitive;
	private var stack:Array<Primitive>;
	private function push( id:Int ) :Void {
		stack.push( current );
		// see if there already is an object with that id.
		current = lookup(id);
		if( current == null ) {
			// create new object
			current = createPrimitive();
			objects.set(id,current);
		} else {
			// clear object
			clearPrimitive( current );
		}
		pushPen();
	}
	private function pop() :Void {
		current = stack.pop();
		if( current == null ) throw("Object Stack Underflow");
		popPen();
	}

	public function createPrimitive() :Primitive {
		return null;
	}
	public function clearPrimitive( p:Primitive ) :Void {
	}

	/* API to override 
	public function getRootPrimitive() :Primitive {
		return null;
	}
	public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
		return null;
	}
	*/

	public function new( ?root:Primitive ) :Void {
		super();
		stack = new Array<Primitive>();
		objects = new IntHash<Primitive>();
		current = root;
		if( current == null ) current = getRootPrimitive();
		objects.set(0,current);
	}
	
	public function draw( i:DrawingInstruction ) :Void {
		switch( i ) {
			case StartObject(id):
				push(id);
			case EndObject:
				pop();
			case ShowObject(id):
				var o = lookup(id);
				if( o==null ) throw("No Object #"+id);
				attachPrimitive( current, o );

			default:
				super.draw(i);
		}
	}
}
