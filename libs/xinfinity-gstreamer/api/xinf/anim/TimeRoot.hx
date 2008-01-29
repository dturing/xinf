/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.event.FrameEvent;
import xinf.ony.Root;

class TimeRoot extends TimeContainer {

	public static var root:TimeContainer = new TimeRoot();

	var time(default,null):Float;
	var rate:Float;

	public function new( ?traits:Dynamic ) {
		super(traits);
		
		time = 0;
		rate = 1/25; // 1/Root.getFramerate();
		
		Root.addEventListener( FrameEvent.ENTER_FRAME, enterFrame );
	}
	
	function enterFrame( e:FrameEvent ) {
		time = started+(e.frame*rate);
		step(time);
	}
	
}
