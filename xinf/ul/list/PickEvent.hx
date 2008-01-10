/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import xinf.event.Event;

class PickEvent<T> extends Event<PickEvent<T>> {
    
    static public var ITEM_PICKED = new xinf.event.EventKind<PickEvent<T>>("itemPicked");

    public var item:T;
    public var index:Int;
    public var addModifier:Bool;
    public var extendModifier:Bool;
    
    public function new( _type:xinf.event.EventKind<PickEvent<T>>, item:T, index:Int, ?add:Bool, ?extend:Bool ) {
        super(_type);
        this.item = item;
        this.index = index;
        this.addModifier = add;
        this.extendModifier = extend;
    }
    
}
