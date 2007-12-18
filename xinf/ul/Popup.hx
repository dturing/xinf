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
    var root:xinf.ony.base.Document;
    
    public function new( parent:Component, o:Component, ?popupMode:PopupMode ) :Void {
        object = o;
        root = parent.getElement().document;
        
        if( popupMode == null ) popupMode = Move;
        
        if( o.position.x < 0 ) o.position = { x:0., y:o.position.y };
        if( o.position.y < 0 ) o.position = { x:o.position.x, y:0. };
		
		// FIXME: if too close to root border, it's invisible!
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
