/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.EnumTrait;
import xinf.anim.type.Time;
import xinf.anim.type.Fill;
import xinf.anim.type.TimeTrait;
import xinf.anim.type.DurationTrait;
import xinf.anim.type.RepeatTrait;

import xinf.ony.Implementation;

class TimedElement extends XMLElement {

	static var TRAITS = {
		begin: new TimeTrait(Offset(0)),
		end: new TimeTrait(),
		dur: new DurationTrait(),
	//	restart: new EnumTrait<Restart>( Restart, Restart.Default ),
	//	restartDefault: new EnumTrait<Restart>( Restart, Restart.Inherit ),
		fill: new EnumTrait<Fill>( Fill, Fill.Default ),
		
		repeatCount: new RepeatTrait(),
		repeatDur: new DurationTrait(),
	}
	
	public var begin(get_begin,set_begin):Time;
	function get_begin() :Time { return getTrait("begin",Time); }
	function set_begin( v:Time ) :Time { setTrait("begin",v); return v; }

	public var end(get_end,set_end):Time;
	function get_end() :Time { return getTrait("end",Time); }
	function set_end( v:Time ) :Time { setTrait("end",v); return v; }

	public var dur(get_dur,set_dur):Null<Float>;
	function get_dur() :Null<Float> { return getTrait("dur",Float); }
	function set_dur( v:Null<Float> ) :Null<Float> { setTrait("dur",v); return v; }

	public var fill(get_fill,set_fill):Fill;
	function get_fill() :Fill { return getStyleTrait("fill",Fill); }
	function set_fill( v:Fill ) :Fill { return setStyleTrait("fill",v); }
	
	public var repeatCount(get_repeat_count,set_repeat_count):Null<Float>;
	function get_repeat_count() :Null<Float> { return getTrait("repeatCount",Float); }
	function set_repeat_count( v:Null<Float> ) :Null<Float> { setTrait("repeatCount",v); return v; }

	/** active is the timeline's "Run" object
		if null, the element is not active.
	**/
	var active:Bool;
	var scheduleHandles:List<Dynamic>;
	var timeContainer:TimeContainer;
	
	var started:Float;
	var freezeTime:Null<Float>;
	var simpleDuration:Null<Float>;
	var activeDuration:Null<Float>;

	public function new( ?traits:Dynamic ) {
		super( traits );
		active=false;
		scheduleHandles = new List<Dynamic>();
	}
	
	public function isActive() :Bool {
		return active;
	}

	public function beginElement() {
		start(0);
	}
	
	public function endElement() {
		stop(0);
	}

	function start( t:Float ) {
		active = true;
		timeContainer.activate(this);
		started = t;
		freezeTime = null;
//		trace("start "+this+" at "+t+"="+(t-started) );
	}
	
	function stop( t:Float ) {
//		trace("stop "+this+" at "+t );
		timeContainer.deactivate( this );
		active = false;
	}

	function resetIteration( time:Float ) {
	}
	
	function frozen( time:Float ) {
	}
	
	function step( time:Float ) :Bool {
		if( time>=started+activeDuration ) {
			if( fill==Fill.Freeze || fill==Fill.Hold ) {
				if( freezeTime==null ) freezeTime=started+activeDuration;
				frozen( freezeTime );
			} else {
				stop(started+activeDuration);
			}
			return false;
		}
		return true;
	}

	public function beginElementAt( offset:Float ) {
		_schedule( Time.Offset(offset), start );
	}

	public function endElementAt( offset:Float ) {
		_schedule( Time.Offset(offset), stop );
	}

	public function pauseElement() :Void {
		throw("pause/resume NYI");
	}
	
	public function resumeElement() :Void {
		throw("pause/resume NYI");
	}
	
	public function seekElement( seekTo:Float ) :Float {
		throw("seek NYI");
		return seekTo;
	}

	override public function onLoad() {
		// find time graph parent
		var e = parentElement;
		while( e!=null && timeContainer==null ) {
			if( Std.is( e, TimeContainer ) ) {
				timeContainer = cast(e);
			} else
				e = e.parentElement;
		}
		if( timeContainer==null ) timeContainer = TimeRoot.root;
			timeContainer.register(this);
		
		reschedule();
	}
	
	override function destruct() {
		if( !super.destruct() ) return false;
		stop(-1);
		for( h in scheduleHandles ) 
			timeContainer.unschedule(h);
		scheduleHandles = new List<Dynamic>();
		timeContainer.unregister(this);		
		return true;
	}
	
	function reschedule() {
		// remove current
		for( h in scheduleHandles ) 
			timeContainer.unschedule(h);
		scheduleHandles = new List<Dynamic>();
		
		// FIXME: begin and end attributes are really TimeLists! and there is no List() Time!
		trace("schedule "+this+".start at "+begin );
		scheduleHandles.add( _schedule( begin, start ) );
		if( end!=null ) scheduleHandles.add( _schedule( end, stop ) );
		
		// calc (local, unconstrained by parent) simple and active duration
		simpleDuration=Math.POSITIVE_INFINITY; // default: Indefinite
		var dur=this.dur;
		if( repeatCount==null ) {
			simpleDuration=activeDuration=null;
		} else if( dur!=null && dur>0 ) { // dur can also be "media" FIXME
			simpleDuration=dur;
			activeDuration=simpleDuration*repeatCount;
		} else if( end!=null ) {
			var end=resolveTime(this.end);
			var begin=resolveTime(this.begin);
			if( begin!=null && end!=null ) {
				activeDuration=end-begin;
			} else {
				activeDuration=Math.POSITIVE_INFINITY;
			}
			simpleDuration=activeDuration/repeatCount;
			if( Math.isNaN(simpleDuration) ) simpleDuration=Math.POSITIVE_INFINITY;
			trace(""+this+" rep "+activeDuration+"/"+repeatCount+"="+simpleDuration );
		}
		/* FIXME more: 
			implicit durations? 
			repeatDur
			etc..
		*/
	}
	
	function resolveTime( time:Time ) :Null<Float> {
		switch( time ) {
			case Offset(t):
				return t;
			case Indefinite:
				return null;
			default:
				return 0;
		}
	}
	
	function _schedule( time:Time, f:Float->Void ) :Dynamic {
		switch( time ) {
			case Offset(t):
				return timeContainer.schedule(t,f);
			case WallClock(date):
				var t = timeContainer.globalToLocalTime(date.getTime()/1000.);
				trace(""+date+", "+date.getTime()+" == local "+t );
				return timeContainer.schedule(
					t,f);
			case Indefinite:
				// do nothing
			// todo #id.begin; events
			default:
				throw("Can't schedule "+time+" (yet)");
		}
		return null;
	}
	 
	override public function toString() :String {
		var s = "";
 		if( id!=null ) s += "#"+id;
 		if( name!=null ) s += "(\""+name+"\")";
		return( Type.getClassName( Type.getClass(this) )+s );
	}

}
