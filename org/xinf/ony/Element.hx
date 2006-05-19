package org.xinf.ony;

import org.xinf.style.StyledObject;
import org.xinf.event.Event;
import org.xinf.ony.impl.IPrimitive;

class Element extends StyledObject {
    public var name:String;
    public var parent:Element;
    
    public var bounds:Bounds;
    
    private var _p:IPrimitive;
    private var children:Array<Element>;

    public function new( _name:String ) :Void {
        name = _name;
        bounds = Bounds.newZero();
//        bounds.addEventListener( Event.CHANGED, onBoundsChanged );
        
        children = new Array<Element>();
        _p = createPrimitive();
        _p.setOwner( this );
        
        super(name);

        _p.setStyle( style );
        _p.setBounds( bounds );
     }

    private function createPrimitive() :IPrimitive {
        throw("dont know which Primitive to create for "+this);
        return null;
    }

    public function addChild( child:Element ) :Void {
        children.push( child );
        child.parent = this;
        _p.addChild( child._p );
    }
    
    public function removeChild( child:Element ) :Void {
        children.remove( child );
        child.parent = null;
        _p.removeChild( child._p );
    }
/*
    public function styleChanged() :Void {
        super.styleChanged();
        // this could be avoided if bg/border/fg couple to the needed styleProperties. FIXME
        _p.applyStyle( style );
    }
    private function onBoundsChanged( e:Event ) {
        // FIXME: avoid this by setting it once (and linking, for js and fl- inity will keep display uptodate)
//        trace( ""+this+".onBoundsChanged");
        _p.applyBounds(bounds);
    }
*/
    
    public function dispatchEvent( e:Event ) :Void {
        super.dispatchEvent( e );
        
        // propagate to parent
        if( !e.stopped && parent != null ) {
            parent.dispatchEvent(e);
        }
    }

    public function addEventListener( type:String, f:Event->Void ) :Void {
        _p.eventRegistered( type );
        super.addEventListener( type, f );
    }
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + " " + name + ">" );
    }
}
