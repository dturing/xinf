/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

class TimeContainer extends TimedElement {

	var sched:Schedule<Float->Void>;
	var activeElements:List<TimedElement>;
	var elements:List<TimedElement>;
	
	public function new( ?traits:Dynamic ) {
		super(traits);
		sched = new Schedule<Float->Void>();
		activeElements = new List<TimedElement>();
		elements = new List<TimedElement>();
		started=Date.now().getTime();
	}
	
	public function schedule( t:Float, f:Float->Void ) {
		sched.insert( t, f );
		return f;
	}

	public function unschedule( f:Float->Void ) {
		sched.remove( f );
		return f;
	}

	public function register( e:TimedElement ) {
		elements.add(e);
	}
	
	public function unregister( e:TimedElement ) {
		elements.remove(e);
	}

	public function activate( e:TimedElement ) {
		activeElements.add(e);
	}
	
	public function deactivate( e:TimedElement ) {
		activeElements.remove(e);
	}

	override function step( time:Float ) {
		time-=started;
		for( f in sched.until(time) ) f(time);
		for( e in activeElements ) e.step( time );
	}

}
