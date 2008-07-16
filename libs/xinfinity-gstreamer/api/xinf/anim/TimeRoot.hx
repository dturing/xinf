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
		started=Date.now().getTime()/1000;
		Root.addEventListener( FrameEvent.ENTER_FRAME, enterFrame );
	}
	
	function enterFrame( e:FrameEvent ) {
		time = started+(e.frame*(1./Root.getFramerate()));
		//trace("frame "+e.frame+", rate "+Root.getFramerate()+" --> time "+time+" (started+"+(time-started)+")" );
		step(time);
	}
	
}
