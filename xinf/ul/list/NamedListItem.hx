/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.xml.Node;
import xinf.ul.model.ISettable;

class NamedListItem<T> implements ISettable<T> {
	
	var cursor:Bool;
	var text:Text;
	var value:T;
	var size:TPoint;
	
	public function setCursor( isCursor:Bool ) :Bool {
		if( isCursor!=cursor ) {
			cursor = isCursor;
		}
		return cursor;
	}
	
	public function new( ?value:T ) :Void {
		text = new Text({ alignmentBaseline:"hanging" });
		this.value = value;
		size = { x:0., y:0. };
		cursor=false;
	}
	
	public function set( ?value:T ) :Void {
		this.value = value;
		text.text = if( value==null ) "" else ""+(untyped { value.name; });
	}
	
	public function setStyle( style:Dynamic ) :Void {
		text.setTraitsFromObject(style);
		text.styleChanged();
	}
	
	public function attachTo( parent:Node ) :Void {
		parent.appendChild(text);
	}

	public function moveTo( x:Float, y:Float ) :Void {
		text.x = x;
		text.y = y; //y+((size.y-text.fontSize)/2);
	}
	
	public function resize( x:Float, y:Float ) :Void {
		size = { x:x, y:y };
	}
}
