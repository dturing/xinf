/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.event.FrameEvent;
import xinf.ony.Root;

class TimeRoot extends TimeContainer {

	public static var root:TimeRoot = new TimeRoot();

	var time(default,null):Float;
	var rate:Float;

	public function new( ?traits:Dynamic ) {
		super(traits);
		
		time = 0;
		started=Date.now().getTime()/1000;
	}
	
	function enterFrame( e:FrameEvent ) {
		time = started+(e.frame*(1./Root.getFramerate()));
	//	trace("frame "+e.frame+", rate "+Root.getFramerate()+" --> time "+time+" (started+"+(time-started)+")" );
		step(time);
	}
	
	public static function start() {
		Root.addEventListener( FrameEvent.ENTER_FRAME, root.enterFrame );
	}
}
