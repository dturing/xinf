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

package xinf.svg;

import xinf.erno.Renderer;
import xinf.style.StyleClassElement;

/**
    SVG Rectangle element.
**/

class Group extends Element {
    public function new() :Void {
        super();
    }
    
    public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( document==null ) throw("Document not set.");
        for( node in xml.elements() ) {
            var child = document.unmarshal( node );
            if( child!=null ) {
                attach( child );
                child.scheduleTransform();
            }
        }
    }
    
    public function getChildByName( name:String ) :Element {
        for( child in children ) {
            var e = cast(child,Element);
            if( e!=null && e.name==name ) return e;
        }
        return null;
    }

    public function getTypedChildByName<T>( name:String, cl:Class<T> ) :T {
        for( child in children ) {
            if( Std.is( child, cl ) ) {
                var e:T = cast(child);
                if( e!=null && untyped e.name==name ) return e;
            }
        }
        return null;
    }
}
