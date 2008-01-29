/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.EnumTrait;

class TimedElement extends XMLElement {

	static var TRAITS = {
		begin: new TimeTrait(),
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
    function set_begin( v:Time ) :Time { setTrait("begin",v); reschedule(); return v; }

    public var end(get_end,set_end):Time;
    function get_end() :Time { return getTrait("end",Time); }
    function set_end( v:Time ) :Time { setTrait("end",v); reschedule(); return v; }

    public var dur(get_dur,set_dur):Null<Float>;
    function get_dur() :Null<Float> { return getTrait("dur",Float); }
    function set_dur( v:Null<Float> ) :Null<Float> { setTrait("dur",v); reschedule(); return v; }

    public var fill(get_fill,set_fill):Fill;
    function get_fill() :Fill { return getStyleTrait("fill",Fill); }
    function set_fill( v:Fill ) :Fill { return setStyleTrait("fill",v); }
	
	public var repeatCount(get_repeat_count,set_repeat_count):Null<Float>;
    function get_repeat_count() :Null<Float> { return getTrait("repeatCount",Float); }
    function set_repeat_count( v:Null<Float> ) :Null<Float> { setTrait("repeatCount",v); reschedule(); return v; }

	/** active is the timeline's "Run" object
		if null, the element is not active.
	**/
    var active:Bool;
	var scheduleHandles:List<Dynamic>;
	var timeContainer:TimeContainer;
	
	var started:Float;
	var simpleDuration:Float;
	var activeDuration:Float;

    public function new( ?traits:Dynamic ) {
        super( traits );
		active=false;
		scheduleHandles = new List<Dynamic>();
	}
	
	public function isActive() :Bool {
		return active;
	}

	public function beginElement() {
		start(-1);
	}
	
	public function endElement() {
		stop(-1);
	}

	function start( t:Float ) {
		active = true;
		timeContainer.activate(this);
		started = t;
	}
	
	function stop( t:Float ) {
		trace("stop "+this );
		timeContainer.deactivate( this );
		active = false;
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
	
	function reschedule() {
		// remove current
		for( h in scheduleHandles ) 
			timeContainer.unschedule(h);
		scheduleHandles = new List<Dynamic>();
		
		// FIXME: begin and end attributes are really TimeLists! and there is no List() Time!
		scheduleHandles.add( _schedule( begin, start ) );
		if( end!=null ) scheduleHandles.add( _schedule( end, stop ) );
		
		// calc (local, unconstrained by parent) simple and active duration
		simpleDuration=null; // default: Indefinite
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
			}
			simpleDuration=activeDuration/repeatCount;
			// FIXME more: implicit durations? simpleDuration when end? etc..
		}
		
	}
	
	function resolveTime( time:Time ) :Float {
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
			case Indefinite:
				// do nothing
			default:
				throw("Can't schedule "+time+" (yet)");
		}
		return null;
	}
	
	function step( time:Float ) {
		if( time>started+activeDuration ) {
			stop(started+activeDuration);
		}
	}
 
    override public function toString() :String {
		var s = "";
 		if( id!=null ) s += "#"+id;
 		if( name!=null ) s += "(\""+name+"\")";
		return( Type.getClassName( Type.getClass(this) )+s );
    }

}
