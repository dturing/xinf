/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.event.Event;
import xinf.event.EventKind;

class TimeEvent extends Event<TimeEvent> {
	
	static public var BEGIN	 = new EventKind<TimeEvent>("begin");
	static public var END	 = new EventKind<TimeEvent>("end");
	
	public var detail:Null<Float>;
	
	public function new( _type:EventKind<TimeEvent>, ?d:Null<Float>=null ) {
		super(_type);
		detail = d;
	}

	override public function toString() :String {
		return( ""+type+"("+detail+")" );
	}
	
}

