package org.xinf.ony;

import org.xinf.style.StyledObject;
import org.xinf.event.Event;
import org.xinf.ony.impl.IPrimitive;

class Element extends StyledObject {
    public var name:String;
    private var _p:IPrimitive;
    
    public function new( _name:String ) :Void {
        name = _name;
        _p = createPrimitive();
        _p.setOwner( this );
        super(name);
    }

    private function createPrimitive() :IPrimitive {
        throw("dont know which Primitive to create for "+this);
        return null;
    }

    public function styleChanged() :Void {
        super.styleChanged();
        _p.applyStyle( style );
    }

    public function addEventListener( type:String, f:Event->Bool ) :Void {
        _p.eventRegistered( type );
        super.addEventListener( type, f );
    }
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + ">" );
    }
}
