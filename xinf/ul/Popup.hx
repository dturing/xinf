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

import Xinf;

enum PopupMode {
    Move;
    Scale;
}

class Popup {
    
    var object:Component;
    var root:xinf.ony.Document;
    
    public function new( parent:Component, o:Component, ?popupMode:PopupMode ) :Void {
        object = o;
        root = parent.getElement().document;
        
        if( popupMode == null ) popupMode = Move;
        
        if( o.position.x < 0 ) o.position = { x:0., y:o.position.y };
        if( o.position.y < 0 ) o.position = { x:o.position.x, y:0. };
        
		switch( popupMode ) {
			case Move:
				if( o.position.x+o.size.x >= root.width ) 
					o.position = { x:root.width - (o.size.x+1), y:o.position.y };
				if( o.position.y+o.size.y >= root.height ) 
					o.position = { x:o.position.x, y:root.height - (o.size.y+1) };
			case Scale:
				if( o.position.x+o.size.x >= root.width ) 
					o.size = { x:root.width - (o.position.x+1), y:o.size.y };
				if( o.position.y+o.size.y >= root.height ) 
					o.size = { x:o.size.x, y:root.height - (o.position.y+1) };
        }
        root.attach(object.getElement());
    }
    
    public function close() :Void {
        root.detach(object.getElement());
    }
    
}
