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

package xinf.ony;

class Wrapper extends Pane {
    var _primitive:Primitive;
    
    public function new( name:String, parent:Element, p:Dynamic ) {
        _primitive = p;
        super(name,parent);
    }
    
    override private function createPrimitive() :Primitive {
        return _primitive;
    }
}
