/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import xinf.ul.Container;
import xinf.ul.FocusManager;
import xinf.event.KeyboardEvent;
import xinf.event.MouseEvent;

/**
    Widget base class.
    Takes care of Keyboard Focus.
**/
class Widget extends Container {
    
    public var focusable:Bool;

    public function new(?traits:Dynamic) :Void {
        super(traits);
        focusable = true;
        FocusManager.register(this);
        
        group.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownWidget );
    }
    
    // FIXME: child classes have their own onMouseDown, which is not really override.
    // is Widget the class that "highlevels" mouseevents towards onClick, onDrag etc? probably!
    private function onMouseDownWidget( e:MouseEvent ) :Void {
        if( focusable ) FocusManager.setFocus(this);
    }
    
    public function focus() :Bool {
        if( !focusable ) {
            return false;
        }
        addStyleClass(":focus");
        return true;
    }

    public function blur() :Void {
        removeStyleClass(":focus");
    }
    
}
