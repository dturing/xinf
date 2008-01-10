/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.xml.Node;
import xinf.ul.model.ISettable;

class ListItem<T> implements ISettable<T> {
    
    var cursor:Bool;
	var text:Text;
    var value:T;
    
    public function setCursor( isCursor:Bool ) :Bool {
        if( isCursor!=cursor ) {
            cursor = isCursor;
        }
        return cursor;
    }
    
    public function new( ?value:T ) :Void {
		text = new Text();
        this.value = value;
        cursor=false;
    }
    
    public function set( ?value:T ) :Void {
        this.value = value;
        text.text = if( value==null ) "" else ""+value;
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
		text.y = y+text.fontSize;
	}
	
	public function resize( x:Float, y:Float ) :Void {
	}
}
