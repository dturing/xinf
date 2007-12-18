/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.event.SimpleEvent;
import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.ul.Component;
import xinf.ul.ValueEvent;

class CheckBox<Value> extends Button<Value> {

    var r1:Rectangle;
    var r2:Rectangle;

	public var selected(default,setSelected) :Bool;
	
	public function setSelected( sel:Bool ) :Bool {
		if( sel != selected) {
			selected = sel;
			if (sel) {
				//addStyleClass(":select")
				group.attach(r2);
			} else {
				//removeStyleClass(":select");
				group.detach(r2);
			}
		}
		return sel;
	}

	public function new( ?initialText:String, ?value:Value ) :Void {
		super( initialText, value );
		selected = false;
		r1 = new Rectangle();
		r1.width = 10.;
		r1.height = 10.;
		r2 = new Rectangle();
		r2.width = 5.;
		r2.height = 5.;
		group.attach(r1);
		selected = false;
	}
	
	override public function set_size( s:TPoint ) :TPoint {
		super.set_size(s);
		positionContents();
		return s;
	}
	
	override public function styleChanged() :Void {
		super.styleChanged();
		//r1.style = getElement().style;
	}
	
	private function positionContents () {
		var w:Null<Float> = r1.width;
		var h:Null<Float> = r1.height;
		if (w!=null) r1.x = (size.x-w)/2;
		if (h!=null) r1.y = (size.y-h)/2;
		r2.x = r1.x+r1.width;
		r2.y = r1.y-r2.height;
		textElement.x = 10.;
		textElement.y = r2.y;
	}
	
 	function onMouseDown( e:MouseEvent ) {
 		super.onMouseDown(e);
 		selected = !selected;
 	}


   /*
    public static function createSimple( text:String, f:ValueEvent<Value>->Void, ?value:Value ) :CheckBox<Value> {
        var b = new CheckBox<Value>( text, value );
        b.addEventListener( Button.PRESS, f );
        return b;
    }*/
    
}
