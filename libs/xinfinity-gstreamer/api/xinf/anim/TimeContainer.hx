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

	// FIXME at least one of these is wrong! test with time shift!
	public function localToGlobalTime( t:Float ) :Float {
		var r = started + t;
		if( timeContainer!=null ) 
			r+=timeContainer.localToGlobalTime(r);
		return r;
	}
	public function globalToLocalTime( t:Float ) :Float {
		var r = t;
		if( timeContainer!=null ) 
			r=timeContainer.globalToLocalTime(r);
		r-=started;
//		trace("global "+t+" - started "+started+" = "+r );
		return r;
	}

	override function step( time:Float ) :Bool {
		time-=started;
//		trace(""+this+" @"+time+"\n"+activeElements );
		sched.callUntil( time, function(f,t) f(t) );
		for( e in activeElements ) e.resetIteration( time );
		for( e in activeElements ) e.step( time );
		return true;
	}

}
