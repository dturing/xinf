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

package xinf.ul;

import xinf.event.SimpleEvent;
import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.ul.model.ISelectable;

class RadioButton<Value> extends CheckBox<Value>, implements ISelectable {
	
	public var group(default,default) :RadioButtonGroup<Value>;

	public function new( grp:RadioButtonGroup<Value>, ?label:String, ?value:Value ) :Void {
		super( label, value );
		group = grp;
		selected = false;
		group.addItem(this);
	}
	
	public function setSelected( sel:Bool ) {
		if( (sel != selected) && !(sel && !group.selectItem(this)) ) {
			selected = sel;
			if (sel) addStyleClass(":select") else removeStyleClass(":select");
		}
		return sel;
	}
	
	public function drawContents( g:Renderer ) :Void {
        var sizeR:Float = Math.min( size.x, size.y ) / 2;
        var r:Float = style.get("selectorWidth", 12) / 2;

        setStyleFill( g, "background" );
        setStyleStroke( g, style.border.l, "color" );
        g.circle( sizeR, sizeR, r );
		
		if( selected ) {
            setStyleStroke( g, 1, "selectColor" );
            setStyleFill( g, "selectBackgroundColor" );
	    	g.circle( sizeR, sizeR, r/2 );
		}

        setStyleFill(g,"color");
        g.text(style.padding.l+(sizeR*2)+style.padding.l,style.padding.t,text,getStyleTextFormat());
    }
	
	public static function createSimple( grp:RadioButtonGroup<Value>, text:String, f:ValueEvent<Value>->Void, value:Value ) :RadioButton<Value> {
        var b = new RadioButton( grp, text, value );
        b.addEventListener( Button.PRESS, f );
        return b;
    }
    
}	
