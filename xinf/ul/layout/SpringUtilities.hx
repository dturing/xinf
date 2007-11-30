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

import xinf.ul.Component;
import xinf.ul.Container;
import xinf.ul.layout.SpringLayout;

class SpringUtilities {
    public static function makeGrid( parent:Container, layout:SpringLayout,
        cols:Int, rows:Int, xPad:Float, yPad:Float ) {
        var xPadSpring = Spring.constant(xPad);
        var yPadSpring = Spring.constant(yPad);
        var initialXSpring = new LeftSpring(parent);
        var initialYSpring = new TopSpring(parent);
        var max = rows * cols;

        // assure we have enough components
        if( parent.getComponent(max-1) == null ) throw("Grid requires "+rows+"x"+cols+" children to be attached.");

        // Springs for assuring all cells have same size
        var maxWidth = layout.getConstraints(parent.getComponent(0)).getWidth();
        var maxHeight = layout.getConstraints(parent.getComponent(0)).getHeight();
        for( i in 1...max ) {
            var cons = layout.getConstraints( parent.getComponent(i) );
            maxWidth = Spring.max( maxWidth, cons.getWidth() );
            maxHeight = Spring.max( maxHeight, cons.getHeight() );
        }
        for( c in parent.getComponents() ) {
            var cons = layout.getConstraints( c );
            cons.setWidth( maxWidth );
            cons.setHeight( maxHeight );
        }
        
        // Springs for adjusting North/West constraints
        var lastCons:Constraints = null;
        var lastRowCons:Constraints = null;
        var i=0;
        for( c in parent.getComponents() ) {
            var cons = layout.getConstraints( c );
            
            if( i%cols == 0 ) {
                // start of new row
                lastRowCons = lastCons;
                cons.setX( initialXSpring );
            } else {
                // x depends on previous
                cons.setX( Spring.sum( lastCons.getEast(), xPadSpring ) );
            }
            
            if( i/cols < 1.0 ) {
                // first row
                cons.setY( initialYSpring );
            } else {
                cons.setY( Spring.sum( lastRowCons.getSouth(), yPadSpring ) );
            }
            lastCons = cons;
            i++;
        }
        
        // parent's size
        var pCons = layout.getConstraints(parent);
        pCons.setEast( Spring.sum( new RightSpring(parent), lastCons.getEast() ) );
        pCons.setSouth( Spring.sum( new BottomSpring(parent), lastCons.getSouth() ) );
        
        return layout;
    }

    public static function makeCompactGrid( parent:Container, layout:SpringLayout,
        cols:Int, rows:Int, xPad:Float, yPad:Float ) {
        var xPadSpring = Spring.constant(xPad);
        var yPadSpring = Spring.constant(yPad);
        
        // Springs for assuring all cells in a column have same width
        var x:Spring = new LeftSpring(parent);
        for( c in 0...cols ) {
            var width = Spring.constant(0);
            for( r in 0...rows ) {
                var comp = parent.getComponent( (r*cols)+c );
                if( comp==null ) throw("Container does not contain enough components for "+cols+"x"+rows+", only "+parent.children.length );
                var cons = layout.getConstraints( comp );
                width = Spring.max( width,
                        cons.getWidth() );
            }
            for( r in 0...rows ) {
                var comp = parent.getComponent( (r*cols)+c );
                if( comp==null ) throw("Container does not contain enough components for "+cols+"x"+rows );
                var cons = layout.getConstraints( comp );
                cons.setX(x);
                cons.setWidth(width);
            }
            x = Spring.sum( x, Spring.sum( width, xPadSpring ) );
        }

        // Springs for assuring all cells in a row have same height
        var y:Spring = new TopSpring(parent);
        for( r in 0...rows ) {
            var height = Spring.constant(0);
            for( c in 0...cols ) {
                var cons = layout.getConstraints( parent.getComponent( (r*cols)+c ) );
                height = Spring.max( height, cons.getHeight() );
            }
            for( c in 0...cols ) {
                var cons = layout.getConstraints( parent.getComponent( (r*cols)+c ) );
                cons.setY(y);
                cons.setHeight(height);
            }
            y = Spring.sum( y, Spring.sum( height, yPadSpring ) );
        }
        
        // parent's size
        var pCons = layout.getConstraints(parent);
        pCons.setWidth( Spring.sum( Spring.sum( x, new RightSpring(parent) ), Spring.minus(xPadSpring) ) );
        pCons.setHeight( Spring.sum( Spring.sum( y, new BottomSpring(parent) ), Spring.minus(yPadSpring) ) );
        
        return layout;
    }
}
