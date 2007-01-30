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

class ComponentValue extends Slot {
    var c:Component;
    
    public function new( c:Component, ?value:Value ) {
        super(value);
        this.c=c;
    }
    public function getValue() :Float {
        if( _v != null ) {
            return super.getValue();
        }
        return getComponentValue();
    }
    public function setValue( v:Float ) :Float {
        if( _v==null ) {
            // slot is empty: propagate the change
            trace( ""+this+" empty, prop change to "+v );
            updateClients(v);
        } else {
            trace( ""+this+" filled, ignore change to "+v );
            // slot is filled: ignore setting.
        }
        return getValue();
    }
    public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        setComponentValue(d.value);
    //    trace("ComponentValue operand changed: "+d+", now: "+d.value );
        super.operandChanged( d, getComponentValue(), oldValue );
    }
    public function set( ?v:Value ) :Void {
        super.set(v);
        if( v!=null ) setComponentValue( v.value );
    }
    
    function setComponentValue( v:Float ) :Void {
    }
    function getComponentValue() :Float {
        return null;
    }

    public function toString() :String {
        return( "("+c+":"+_v+":"+getValue()+" )" );
    }
}

class ComponentWidth extends ComponentValue {
    function getComponentValue() :Float {
        return c.size.x;
    }
    function setComponentValue( v:Float ) :Void {
        c.resize( Math.max(c.style.get("minWidth",0),v), c.size.y );
    }
    public function toString() :String {
        return( "W"+super.toString() );
    }
}

class ComponentHeight extends ComponentValue {
    function getComponentValue() :Float {
        return c.size.y;
    }
    function setComponentValue( v:Float ) :Void {
        c.resize( c.size.x, Math.max(c.style.get("minHeight",0),v) );
//        c.resize( c.size.x, v );
    }
    public function toString() :String {
        return( "H"+super.toString() );
    }
}

class ComponentX extends ComponentValue {
    function getComponentValue() :Float {
        return c.position.x;
    }
    function setComponentValue( v:Float ) :Void {
        c.moveTo( v, c.position.y );
    }
    public function toString() :String {
        return( "X"+super.toString() );
    }
}

class ComponentY extends ComponentValue {
    function getComponentValue() :Float {
        return c.position.y;
    }
    function setComponentValue( v:Float ) :Void {
        c.moveTo( c.position.x, v );
    }
    public function toString() :String {
        return( "y"+super.toString() );
    }
}
/*
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
*/