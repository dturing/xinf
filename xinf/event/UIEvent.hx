/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
	
**/
class UIEvent extends Event<UIEvent> {
	
	static public var ACTIVATE = new EventKind<UIEvent>("activate",true);

	public var targetId:Null<Int>;

	public function new( _type:EventKind<UIEvent>, ?targetId:Int ) {
		super(_type);
		this.targetId = targetId;
	}

}
