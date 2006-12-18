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
import xinf.ony.Root;
import xinf.ony.Object;

enum PopupMode {
	Move;
	Scale;
}

class Popup {
	
	var object:Object;
	var root:Object;
	
	public function new( parent:Object, o:Object, ?popupMode:PopupMode ) :Void {
		object = o;
		root = parent;
		while( root.parent!=null ) {
			root=root.parent;
		}
		
		if( popupMode == null ) popupMode = Move;
		
		if( o.position.x < 0 ) o.moveTo( 0, o.position.y );
		if( o.position.y < 0 ) o.moveTo( o.position.x, 0 );
		
		if( root.size.x != 0 ) {
			switch( popupMode ) {
				case Move:
					if( o.position.x+o.size.x >= root.size.x ) 
						o.moveTo( root.size.x - (o.size.x+1), o.position.y );
					if( o.position.y+o.size.y >= root.size.y ) 
						o.moveTo( o.position.x, root.size.y - (o.size.y+1) );
				case Scale:
					if( o.position.x+o.size.x >= root.size.x ) 
						o.resize( root.size.x - (o.position.x+1), o.size.y );
					if( o.position.y+o.size.y >= root.size.y ) 
						o.resize( o.size.x, root.size.y - (o.position.y+1) );
			}
		}
		root.attach(object);
	}
	
	public function close() :Void {
		root.detach(object);
	}
	
}
