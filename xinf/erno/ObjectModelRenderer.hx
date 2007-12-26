/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.erno.PenRenderer;
import xinf.erno.Renderer;

/**
	DOCME: out of date!
	
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
class ObjectModelRenderer<Primitive> extends PenRenderer {
    
    private var objects:IntHash<Primitive>;
    
    private function lookup( id:Int ) :Primitive {
        var o = objects.get(id);
        if( o==null ) {
            o = createPrimitive(id);
            objects.set(id,o);
        }
        return o;
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
		free resources (notably memory) associated to the given Object.
    **/
    public function destroyPrimitive( p:Primitive ) :Void {
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
        set the transformation of the given object to the given Matrix.
    **/
    public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
    }

    /**
        to be overridden by deriving classes, 
        set the translation of the given object to the given Position.
    **/
    public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
    }

    /* public API */
    public function new() :Void {
        super();
        objects = new IntHash<Primitive>();
    }

    // we implement the root and object parts of the erno Instruction protocol
    override public function startNative( o:NativeContainer ) :Void {
        // TODO #if debug, check if current is set

        // FIXME cast unneccessary if type parameter (Primitive) was constrained to NativeContainer
        // causes problem in haxe: "Should implement by using an interface or a class". 
        // see ml 2006-12-13. (fixed on cvs)
        current=cast(o);
        clearPrimitive(current);
    }
    
    override public function endNative() :Void {
        current=null;
    }

    override public function startObject( id:Int ) {
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
    }
    
    override public function endObject() {
        current = null;
    }

	override public function destroyObject( id:Int ) :Void {
        var o = lookup(id);
		objects.remove(id);
		destroyPrimitive( o );
	}
    
    override public function showObject( id:Int ) {
        var o = lookup(id);
        attachPrimitive( current, o );
    }
    
    override public function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) {
        var o = lookup(id);
        setPrimitiveTransform( o, x, y, a, b, c, d );
    }

    override public function setTranslation( id:Int, x:Float, y:Float ) {
        var o = lookup(id);
        setPrimitiveTranslation( o, x, y );
    }

}
