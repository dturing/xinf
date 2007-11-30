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

import xinf.ul.Container;

class GridLayout extends SpringLayout {
    public var cols:Int;
    public var compact:Bool;
    var springsDone:Bool;
    
    public function new( ?cols:Int, ?compact:Bool ) :Void {
        super();
        springsDone=false;
        cols = if( cols==null ) 1 else cols;
        compact = if( compact==null ) false else compact;
    }
    
    public function layoutContainer( p:Container ) {
        if( !springsDone ) {
            var count = p.children.length;
            var rows = Math.ceil( count/cols );
            if( compact ) {
                trace("MakeCompactGrid "+cols+"x"+rows );
                SpringUtilities.makeCompactGrid(
                    p, this, cols, rows, 1, 1 ); // FIXME pad
            } else {
                trace("MakeGrid "+cols+"x"+rows );
                SpringUtilities.makeGrid(
                    p, this, cols, rows, 3, 3 ); // FIXME pad
            }
            springsDone=true;
        }
        super.layoutContainer(p);
    }
}