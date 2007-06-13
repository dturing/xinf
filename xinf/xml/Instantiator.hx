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

package xinf.xml;

class Instantiator<T:Serializable> {
    var myClass : Class<T>;
    public function new( m:Class<T> ) {
        myClass = m;
    }
    
    public function fits( xml:Xml ) :Bool {
        return false;
    }
    
    public function getClass( xml:Xml ) :Class<T> {
        return myClass;
    }
}

class ByPropertyValue<T:Serializable> extends Instantiator<T> {
    var propName:String;
    var propValue:String;
    
    public function new( propName:String, propValue:String, m:Class<T> ) {
        super(m);
        this.propName = propName;
        this.propValue = propValue;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(propName) == propValue );
    }
}

class HasProperty<T:Serializable> extends Instantiator<T> {
    var propName:String;
    
    public function new( propName:String, m:Class<T> ) {
        super(m);
        this.propName = propName;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(propName) != null );
    }
}