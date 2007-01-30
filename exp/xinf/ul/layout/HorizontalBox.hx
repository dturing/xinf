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

class HorizontalBox extends LayoutContainer {
    public static var ALIGN_TOP:Float = null;
    public static var ALIGN_MIDDLE:Float = 0.5;
    public static var ALIGN_BOTTOM:Float = 1.0;

    var currentX:Value;
    var maxHeight:Expression;

    public function new() :Void {
        super();
        currentX = pad.t;
        maxHeight = Value.max();
        constraints.setHeight( Value.sum( pad.t, pad.b, maxHeight ));
    }

    public function align( c:Component, align:Float ) :Void {
        if( align!=null ) {
            c.constraints.setY( Value.sum( pad.t, Value.scale( align,
                Value.sum( maxHeight, Value.minus( c.constraints.getHeight() ) ) )));
        } else {
            c.constraints.setY( pad.t );
        }
    }
    
    public function add( c:Component, ?a:Float ) :Void {
        attach( c );
        if( a!=null ) this.align( c, a );
    }
    
    override public function attach( c:Component ) :Void {
        super.attach( c );
        c.constraints.setX( currentX );
        c.constraints.setY( pad.t );
        currentX = Value.sum( c.constraints.getEast(), spacing.h );
        constraints.setWidth( currentX );
        
        maxHeight.addOperand( c.constraints.getHeight() );
    }
}
