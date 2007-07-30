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

import xinf.ony.Object;
import xinf.ul.Component;
import xinf.ul.Container;

class ConstrainedLayout<Constraint> {
    var index:IntHash<Constraint>;
    
    public function new() :Void {
        index = new IntHash<Constraint>();
    }
    
    public function getConstraints( comp:Component ) :Constraint {
        var c:Constraint = index.get( comp._id );
        if( c==null ) {
            c = createConstraints();
            index.set( comp._id, c );
        }
        return c;
    }
    
    public function setConstraint( comp:Component, c:Constraint ) :Void {
        index.set( comp._id, c );
    }
    
    public function createConstraints() :Constraint {
        return null;
    }
}
