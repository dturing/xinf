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

import xinf.event.MouseEvent;
import xinf.erno.Renderer;
import xinf.erno.Color;

class RadioButton extends CheckBox, implements ISelectable {
	
	public var data(default,default) :Dynamic;
	public var group(default,default) :RadioButtonGroup;

	public function new( grp:RadioButtonGroup, ?label:String, ?dat:Dynamic ) :Void {
		super( label );
		group = grp;
		data = dat;
		selected = false;
		toggle = true;
		group.addInstance(this);
	}
	
	private function setSelected( sel:Bool ) {
		if( (sel != selected) && !(sel && !group.selectInstance(this)) ) {
			selected = sel;
			if (sel) addStyleClass(":select") else removeStyleClass(":select");
		}
		return sel;
	}
	
	public function drawContents( g:Renderer ) :Void {
    	if( crop )
        	g.clipRect( size.x-2, size.y-2 );
            
        var sizeR:Float = Math.min( size.x, size.y ) / 2;
        var r:Float = style.get("selectorWidth", 12) / 2;

        if( style.background != null ) {
            g.setFill( style.background.r, style.background.g, style.background.b, style.background.a );
            g.setStroke( 0,0,0,0,0 );
            g.circle( sizeR, sizeR, r );
        }

    	if( style.border.l > 0 ) {
            var b = style.border.l/4;
            g.setFill(0,0,0,0);
            g.setStroke(style.color.r,style.color.g,style.color.b,style.color.a,style.border.l);
            g.circle( sizeR, sizeR, r+b );
        }
		
		if( selected ) {
            var c = style.get("selectColor", new Color().fromRGBInt(0));
            g.setStroke(c.r,c.g,c.b,c.a,1);
	    	c = style.get("selectBackgroundColor", new Color().fromRGBInt(0));
            g.setFill(c.r,c.g,c.b,c.a);
	    	g.circle( sizeR, sizeR, r/2 );
		}
    }
	
	public static function createSimple( grp:RadioButtonGroup, text:String, dat:Dynamic, f:MouseEvent->Void ) :RadioButton {
        var b = new RadioButton( grp, text, dat );
        b.addEventListener( Button.CLICK, f );
        return b;
    }
    
}	
