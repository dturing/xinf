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

class CheckBox extends Button<xinf.ul.Label> {
	
	public var toggle(default,default) :Bool;
	public var selected(default,setSelected) :Bool;
	
	private function setSelected( sel:Bool ) {
		if( sel != selected ) {
			selected = sel;
			if (sel) addStyleClass(":select") else removeStyleClass(":select");
		}
		return sel;
	}
	
	public function new( ?initialText:String ) :Void {
		super();
		selected = false;
		toggle = true;
		crop = true;
		var c = new xinf.ul.Label();
		if( initialText!=null ) c.text = initialText;
        contained = c;
	}
	
	public function resize( x:Float, y:Float ) :Void {
		super.resize( x, y );
		var w:Float = Math.max( style.get("minWidth",0), x );
        var h:Float = Math.max( style.get("minHeight",0), y );
        var selectorW:Float = Math.min( style.get("selectorWidth", 12), Math.min( w, h ) );
        var labelW:Float = w - style.padding.l - (2 * style.padding.r) - selectorW;
        var labelH:Float = h - style.padding.t - style.padding.b;

        if( labelW != contained.size.x ) {
        	contained.resize( labelW, labelH );
        	contained.moveTo( size.x - style.padding.r - contained.size.x, (size.y - contained.size.y) / 2);
        }
    }
    
    private function onMouseDown( e:MouseEvent ) {
    	if( ! selected ) {
    		selected = true;
    	} else if( toggle ) {
    		selected = false;
    	}
    	super.onMouseDown( e );
    }
    
    public function drawContents( g:Renderer ) :Void {
    	if( crop )
        	g.clipRect( size.x-2, size.y-2 );
            
        var sizeW:Float = Math.min( size.x, size.y );
        var w:Float = Math.min( style.get("selectorWidth", 10), sizeW );
        if( style.background != null ) {
            g.setFill( style.background.r, style.background.g, style.background.b, style.background.a );
            g.setStroke( 0,0,0,0,0 );
            g.rect( style.padding.l, (size.y-w)/2, w, w );
        }
    	
    	if( style.border.l > 0 ) {
            var b = style.border.l/4;
            g.setFill(0,0,0,0);
            g.setStroke(style.color.r,style.color.g,style.color.b,style.color.a,style.border.l);
            g.rect( style.padding.l-b, (size.y-w)/2-b, w+(2*b), w+(2*b) );
        }
    	
    	//zb: TODO fix focus color appearing where tick should be in selectColor
    	if( selected ) {
            var c = style.get("selectColor", new Color().fromRGBInt(0));
            
            #if js
                g.setFill(c.r,c.g,c.b,c.a);
                g.setStroke(0,0,0,0,0);
                g.rect( style.padding.l+(w/2), (size.y-(w/2))/2, w/2, w/2 );
            #else true
                g.setFill(0,0,0,0);
                g.setStroke(c.r,c.g,c.b,c.a,1);

                g.startShape();
                g.startPath( style.padding.l + w/5, style.padding.t + w*3/5 );
                g.lineTo( style.padding.l + w/2, style.padding.t + w*9/10 );
                g.lineTo( style.padding.l + w*9/10, style.padding.t + w/5 );
                g.endPath();
                g.endShape();
            #end
    	}
    }
   
    public static function createSimple( text:String, f:MouseEvent->Void ) :CheckBox {
        var b = new CheckBox( text );
        b.addEventListener( Button.CLICK, f );
        return b;
    }
    
}
