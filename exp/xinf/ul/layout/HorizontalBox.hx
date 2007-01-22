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
import xinf.ul.Pane;
import xinf.value.Value;
import xinf.style.Style;

class HorizontalBox extends Pane {
    public static var ALIGN_TOP:Float = null;
    public static var ALIGN_MIDDLE:Float = 0.5;
    public static var ALIGN_BOTTOM:Float = 1.0;

    var xPadding:Value;
    var yPadding:Value;
    var currentX:Value;
    var maxHeight:Expression;

    public function new() :Void {
        xPadding = Value.constant(0);
        yPadding = Value.constant(0);
        currentX = xPadding;
        maxHeight = Value.max();
        super();
        constraints.setHeight( Value.sum( Value.scale(2,yPadding), maxHeight ));
    }
    
    override public function applyStyle( s:Style ) :Void {
        super.applyStyle(s);
        xPadding.value = s.padding.l;
        yPadding.value = s.padding.t;
    }
    
    public function add( c:Component, ?align:Float ) :Void {
        attach( c );
        c.constraints.setX( currentX );
        currentX = Value.sum( c.constraints.getEast(), xPadding );
        constraints.setWidth( currentX );
        
        maxHeight.addOperand( c.constraints.getHeight() );
        
        if( align!=null ) {
            c.constraints.setY( Value.sum( yPadding, Value.scale( align,
                Value.sum( maxHeight, Value.minus( c.constraints.getHeight() ) ) )));
        }
    }
}
