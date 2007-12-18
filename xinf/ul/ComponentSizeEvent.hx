/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import xinf.event.Event;
import xinf.event.EventKind;

/**
    ComponentSizeEvent is used to propagate information about changes
    in size of some Component.
**/
class ComponentSizeEvent extends Event<ComponentSizeEvent> {
    
    static public var PREF_SIZE_CHANGED= new EventKind<ComponentSizeEvent>("prefSizeChanged");
    
    public var x:Float; // width
    public var y:Float; // height
    public var component:Component;
    
    public function new( _type:EventKind<ComponentSizeEvent>, _x:Float, _y:Float, _c:Component ) {
        super(_type);
        x=_x; y=_y;
        component = _c;
    }

    override public function toString() :String {
        return( ""+type+"("+x+","+y+")" );
    }
    
}