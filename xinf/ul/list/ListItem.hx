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

package xinf.ul.list;

import Xinf;
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
    
	public function setStyle( style:ElementStyle ) :Void {
		text.style = style;
	}
	
    public function attachTo( parent:Group ) :Void {
        parent.attach(text);
    }

	public function moveTo( x:Float, y:Float ) :Void {
		text.x = x;
		text.y = y;
	}
	
	public function resize( x:Float, y:Float ) :Void {
	}
}
