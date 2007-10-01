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

class CheckBox<Value> extends Button<Value> {

    private var label:Label;
    private var button:Component;

	public var selected(default,setSelected) :Bool;
	
	public function setSelected( sel:Bool ) {
		if( sel != selected ) {
			selected = sel;
			if (sel) addStyleClass(":select") else removeStyleClass(":select");
		}
		return sel;
	}
	
	public function new( ?initialText:String, ?value:Value ) :Void {
		super( initialText, value );
		selected = false;
		addEventListener( Button.PRESS, onPress );
	}
/*	
	public function resize( x:Float, y:Float ) :Void {
		super.resize( x, y );
		var w:Float = Math.max( style.get("minWidth",0), x );
        var h:Float = Math.max( style.get("minHeight",0), y );
        var selectorW:Float = Math.min( style.get("selectorWidth", 12), Math.min( w, h ) );
        var labelW:Float = w - style.padding.l - (2 * style.padding.r) - selectorW;
        var labelH:Float = h - style.padding.t - style.padding.b;
    }
*/    
    private function onPress( e:ValueEvent<Value> ) {
        selected = !selected;
    }
    
    public function drawContents( g:Renderer ) :Void {
        var sizeW:Float = Math.min( size.x, size.y );
        var w:Float = Math.min( style.get("selectorWidth", 10), sizeW );
        
        setStyleFill( g, "background" );
        setStyleStroke( g, style.border.l, "color" );
        g.rect( style.padding.l, (size.y-w)/2, w, w );
        
    	//zb: TODO fix focus color appearing where tick should be in selectColor
    	if( selected ) {
            var c = style.get("selectColor", new Color().fromRGBInt(0));
            
            #if js
                setStyleStroke( g, 1, "selectBackgroundColor" );
                setStyleFill( g, "selectColor" );
                g.rect( style.padding.l+(w/2), (size.y-(w/2))/2, w/2, w/2 );
            #else true
                setStyleStroke( g, 1, "selectColor" );
                g.setFill( 0,0,0,0 );

                g.startShape();
                g.startPath( style.padding.l + w/5, style.padding.t + w*3/5 );
                g.lineTo( style.padding.l + w/2, style.padding.t + w*9/10 );
                g.lineTo( style.padding.l + w*9/10, style.padding.t + w/5 );
                g.endPath();
                g.endShape();
            #end
    	}

        setStyleFill(g,"color");
        g.text(style.padding.l+sizeW+style.padding.l,style.padding.t,text,getStyleTextFormat());
    }
   
    public static function createSimple( text:String, f:ValueEvent<Value>->Void, ?value:Value ) :CheckBox<Value> {
        var b = new CheckBox<Value>( text, value );
        b.addEventListener( Button.PRESS, f );
        return b;
    }
    
}
