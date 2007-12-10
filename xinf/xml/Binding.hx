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

class Binding<T> {
    var marshallers:Hash<Class<T>>;
    var instantiators:Array<Instantiator<T>>;
    
    public function new() :Void {
        marshallers = new Hash<Class<T>>();
        instantiators = new Array<Instantiator<T>>();
    }
    public function add( nodeName:String, m:Class<T> ) :Void {
        marshallers.set( nodeName, m );
    }
    public function addInstantiator( i:Instantiator<T> ) :Void {
        instantiators.push( i );
    }
    public function instantiate( xml:Xml ) :T {
        var m:Class<T>;
        for( i in instantiators ) {
            if( m==null && i.fits(xml) ) m=i.getClass(xml);
        }
        if( m==null ) m = marshallers.get( xml.nodeName );
		if( m==null ) return null;
		var ret:T = Type.createInstance( m, [ null ] );
        return ret;
    }
}

