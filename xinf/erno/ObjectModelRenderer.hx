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

/**
    The ObjectModelRenderer class implements some functionality for
    Renderers that use an object-model based engine (which is currently
    true for all available renderers).
    <p>
        It implements the <i>object parts</i> of the <a href="Renderer.html">Renderer</a>
        interface, keeps a global IntHash mapping Xinferno IDs to NativeObjects (here,
        these are called '[Primitive]'s. The type parameter is in fact required to be
        the same as [NativeObject]. FIXME: clean this up a little!
    </p>
    <p>
        Deriving classes should ignore the [startObject], [endObject], [startNative],
        [endNative], [showObject] and [setTransform] functions of the Renderer interface
        (i.e., not implement them), and instead implement the [createPrimitive],
        [attachPrimitive], [clearPrimitive] and [setPrimitiveTransform] functions
        declared here. The default implementations of those do nothing. Deriving classes
        can access the private member [current] to get access to the NativeObject currently
        being (re-)defined.
    </p>
**/
class ObjectModelRenderer<Primitive> extends PenStackRenderer {
    
    private var objects:IntHash<Primitive>;
    
    private function lookup( id:Int ) :Primitive {
        return objects.get(id);
    }
    
    private var current:Primitive;

    /**
        to be overridden by deriving classes, 
        this function returns a newly
        allocated native object associated to the given ID.
    **/
    public function createPrimitive(id:Int) :Primitive {
        return null;
    }
    
    /**
        to be overridden by deriving classes, 
        attach the [child] to the [parent] object,
        i.e., insert it, addChild, however you want to call it.
    **/
    public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
    }
    
    /**
        to be overridden by deriving classes, 
        clear the given object (remove all its children, clear an
        eventually existing graphics context).
    **/
    public function clearPrimitive( p:Primitive ) :Void {
    }
    
    /**
        to be overridden by deriving classes, 
        set the transformation of the given object to the given Transform.
    **/
    public function setPrimitiveTransform( p:Primitive, t:Transform ) :Void {
    }
    
    /* public API */
    public function new() :Void {
        super();
        objects = new IntHash<Primitive>();
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
