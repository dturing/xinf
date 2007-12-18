/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
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
