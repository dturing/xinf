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

import xinf.ony.Element;
import xinf.geom.Types;
import xinf.event.SimpleEventDispatcher;

class Component extends SimpleEventDispatcher {
    public var __parentSizeListener:Dynamic;

    public var prefSize(getPrefSize,null):TPoint;
    var _prefSize:TPoint;
	
	var size:TPoint;
	var element:Element;

    public function new( ?e:Element ) :Void {
		super();
        _prefSize = { x:.0, y:.0 };
		element=e;
    }

    public function getPrefSize() :TPoint {
        return( _prefSize );
    }
    
    public function setPrefSize( n:TPoint ) :TPoint {
        var s = n; //addPadding(n);
        if( _prefSize==null || s.x!=_prefSize.x || s.y!=_prefSize.y ) {
            _prefSize = s;
            postEvent( new ComponentSizeEvent( ComponentSizeEvent.PREF_SIZE_CHANGED, _prefSize.x, _prefSize.y, this ) );
        }
        return( _prefSize );
    }
	
	// perform the actual resizing, called by the layout manager
	public function resize( s:TPoint ) :Void {
		size = s;
	}

    public function getElement() :Element {
		return element;
    }

}
