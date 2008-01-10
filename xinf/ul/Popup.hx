/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;

enum PopupMode {
    Move;
    Scale;
}

class Popup {
    
    var object:Component;
    
    public function new( parent:Component, o:Component, ?popupMode:PopupMode ) :Void {
        object = o;
        
        if( popupMode == null ) popupMode = Move;
        
        if( o.position.x < 0 ) o.position = { x:0., y:o.position.y };
        if( o.position.y < 0 ) o.position = { x:o.position.x, y:0. };
		
		// FIXME: if too close to Root border, it's invisible!
        switch( popupMode ) {
			case Move:
				if( o.position.x+o.size.x >= Root.width ) 
					o.position = { x:Root.width - (o.size.x+1), y:o.position.y };
				if( o.position.y+o.size.y >= Root.height ) 
					o.position = { x:o.position.x, y:Root.height - (o.size.y+1) };
			case Scale:
				if( o.position.x+o.size.x >= Root.width ) 
					o.size = { x:Root.width - (o.position.x+1), y:o.size.y };
				if( o.position.y+o.size.y >= Root.height ) 
					o.size = { x:o.size.x, y:Root.height - (o.position.y+1) };
        }
		Root.appendChild(object.getElement());
    }
    
    public function close() :Void {
        Root.removeChild(object.getElement());
    }
    
}
