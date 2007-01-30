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
import xinf.ul.ComponentContainer;
import xinf.ul.Pane;
import xinf.value.Value;
import xinf.style.Style;

class VerticalBox extends LayoutContainer {
    public static var ALIGN_LEFT:Float = null;
    public static var ALIGN_CENTER:Float = 0.5;
    public static var ALIGN_RIGHT:Float = 1.0;

    var currentY:Value;
    var maxWidth:Expression;

    public function new() :Void {
        super();
        currentY = pad.l;
        maxWidth = Value.max();
        constraints.setWidth( Value.sum( pad.l, pad.r, maxWidth ));
    }
    
    public function align( c:Component, align:Float ) :Void {
        if( align!=null ) {
            c.constraints.setX( Value.sum( pad.l, Value.scale( align,
                Value.sum( maxWidth, Value.minus( c.constraints.getWidth() ) ) )));
        } else {
            c.constraints.setX( pad.l );
        }
    }
    
    public function add( c:Component, ?a:Float ) :Void {
        attach( c );
        if( a!=null ) align( c, a );
    }
    
    override public function attach( c:Component ) :Void {
        super.attach( c );
        c.constraints.setY( currentY );
        c.constraints.setX( pad.l );
        currentY = Value.sum( c.constraints.getSouth(), spacing.v );
        constraints.setHeight( currentY );
        
        maxWidth.addOperand( c.constraints.getWidth() );
    }
}
