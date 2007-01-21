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

package xinf.ul.layout;

import xinf.value.Value;
import xinf.ul.Component;

class ComponentValue extends Value {
    var c:Component;
    
    public function new( c:Component ) {
        this.c=c;
    }
    public function setValue( v:Float ) :Float {
        throw( ""+this+" is constant" );
        return getValue();
    }
}

class ComponentWidth extends ComponentValue {
    public function getValue() :Float {
        return c.size.x;
    }
    public function setValue( v:Float ) :Float {
        updateClients( c.size.x );
        return c.size.x;
    }
    public function toString() :String {
        return( "W("+c+":"+c.size.x+")" );
    }
}

class ComponentHeight extends ComponentValue {
    public function getValue() :Float {
        return c.size.y;
    }
    public function setValue( v:Float ) :Float {
        updateClients( c.size.y );
        return c.size.y;
    }
    public function toString() :String {
        return( "H("+c+")" );
    }
}

class ComponentX extends ComponentValue {
    public function getValue() :Float {
        return c.position.x;
    }
    public function setValue( v:Float ) :Float {
        c.moveTo( v, c.position.y );
        return c.position.x;
    }
    public function toString() :String {
        return( "X("+c+")" );
    }
}

class ComponentSlot extends Slot {
    var c:Component;
    
    public function new( c:Component, ?v:Value ) {
        super(v);
        this.c=c;
    }
    public function setValue( v:Float ) :Float {
        throw( ""+this+" is constant" );
        return getValue();
    }
}

class ComponentXSetter extends ComponentSlot {
    public function new( c:Component, ?v:Value ) {
        super(c,v);
        if( v!=null ) setValue( getValue() );
    }
    public function getValue() :Float {
    //    trace("get xset: ");
        return super.getValue();
    }
    public function setValue( v:Float ) :Float {
        //updateClients( c.size.y, v );
     //   trace("set "+this+": "+v );
        c.moveTo( v, c.position.y );
        return v;
    }
    public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
     //trace("X SETTER UPDATE: "+this+":"+newValue);
     //   trace(" /// "+getValue());
        if( newValue==null ) newValue = getValue();
        setValue( newValue );
        updateClients( newValue, oldValue );
    }
    public function toString() :String {
        return( "X("+c+")="+_v );
    }
}
