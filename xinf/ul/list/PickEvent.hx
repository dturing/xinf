/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import xinf.event.Event;

class PickEvent<T> extends Event<PickEvent<T>> {
	
// there is no more global ITEM_PICKED event, use myListView.PICKED.
//	static public var ITEM_PICKED = new xinf.event.EventKind<PickEvent<T>>("itemPicked");

	public var item:T;
	public var index:Int;
	public var addModifier:Bool;
	public var extendModifier:Bool;
	public var x:Float;
	public var y:Float;
	public var xOffset:Float;
	public var yOffset:Float;
	
	public function new( _type:xinf.event.EventKind<PickEvent<T>>, item:T, index:Int, ?add:Bool, ?extend:Bool, ?x:Float, ?y:Float, ?xOffset:Float, ?yOffset:Float ) {
		super(_type);
		this.item = item;
		this.index = index;
		this.addModifier = add;
		this.extendModifier = extend;
		this.x = x;
		this.y = y;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
	}
	
}
