/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;
import xinf.traits.TraitDefinition;
import xinf.anim.type.Additive;
import xinf.anim.type.Accumulate;
import xinf.anim.type.CalcMode;
import xinf.anim.type.ValuesTrait;

private typedef Step = { 
	begin:Float, end:Float, 
	from:Dynamic, to:Dynamic,
	interpolate:Dynamic->Dynamic->Float->Dynamic 
};

class Animation extends TimedAttributeSetter {

	static var TRAITS = {
		additive: new EnumTrait<Additive>( Additive, Additive.Replace ),
		accumulate: new EnumTrait<Accumulate>( Accumulate, Accumulate.None ),
		calcMode: new EnumTrait<CalcMode>( CalcMode, CalcMode.Discrete ),
		
	//	keySplines: new StringTrait(),
	//	keyTimes: new FloatListTrait(),
		
		values: new ValuesTrait(),
		from: new StringTrait(),
		to: new StringTrait(),
		by: new StringTrait(),
	}

    public var additive(get_additive,set_additive):Additive;
    function get_additive() :Additive { return getStyleTrait("additive",Additive); }
    function set_additive( v:Additive ) :Additive { return setStyleTrait("additive",v); }

    public var accumulate(get_accumulate,set_accumulate):Accumulate;
    function get_accumulate() :Accumulate { return getTrait("accumulate",Accumulate); }
    function set_accumulate( v:Accumulate ) :Accumulate { return setTrait("accumulate",v); }

    public var calcMode(get_calc_mode,set_calc_mode):CalcMode;
    function get_calc_mode() :CalcMode { return getTrait("calcMode",CalcMode); }
    function set_calc_mode( v:CalcMode ) :CalcMode { return setTrait("calcMode",v); }

    public var values(get_values,set_values):Array<String>;
    function get_values() :Array<String> { return getTrait("values",Array); }
    function set_values( v:Array<String> ) :Array<String> { setTrait("values",v); reschedule(); return v; }

    public var from(get_from,set_from):String;
    function get_from() :String { return getTrait("from",String); }
    function set_from( v:String ) :String { setTrait("from",v); reschedule(); return v; }

    public var to(get_to,set_to):String;
    function get_to() :String { return getTrait("to",String); }
    function set_to( v:String ) :String { setTrait("to",v); reschedule(); return v; }

    public var by(get_by,set_by):String;
    function get_by() :String { return getTrait("by",String); }
    function set_by( v:String ) :String { setTrait("by",v); reschedule(); return v; }

	var steps:Array<Step>;
	var originalValue:Dynamic;
	var lastValue:Dynamic;
	var targetDefinition:TraitDefinition;
	
	function createSteps() :Void {
		steps = new Array<Step>();
		
		var interpolate = null;
		if( calcMode != CalcMode.Discrete ) {
			interpolate = targetDefinition.interpolate;
		}
		
		var vals;
		
		if( from!=null ) {
			if( to!=null ) {
				vals = [ targetDefinition.fromDynamic(from), targetDefinition.fromDynamic(to) ];
			} else if( by!=null ) {
				vals = [ targetDefinition.fromDynamic(from), 
					targetDefinition.add( targetDefinition.fromDynamic(from), targetDefinition.fromDynamic(by) ) ];
			} else {
				trace("invalid animation: only from is given");
				return;
			}
		} else if( by!=null ) {
			vals = [ originalValue, targetDefinition.add(originalValue,targetDefinition.fromDynamic(by)) ];
		} else if( to!=null ) {
			vals = [ originalValue, targetDefinition.fromDynamic(to) ]; // FIXME: 0, not targetDefinitionault...
		} else {
			vals = new Array<Dynamic>();
			for( v in values ) {
				vals.push( targetDefinition.fromDynamic(v) );
			}
		}
		
		var totalLength = null;
		if( calcMode == CalcMode.Paced ) {
			totalLength=0.;
			for( i in 0...(vals.length-1) ) {
				totalLength += targetDefinition.distance( vals[i], vals[i+1] );
			}
		}

		if( vals.length==1 ) {
			var v = vals[0];
			var step = {
				begin: 0.,
				end:   1.,
				from:  v,
				to:    v,
				interpolate: null
			};
			steps.push(step);
		} else {
			var coveredLength = 0.;
			for( i in 0...(vals.length-1) ) {
				var begin; var end;
				if( totalLength!=null ) {
					var l = targetDefinition.distance( vals[i], vals[i+1] );
					begin = coveredLength/totalLength;
					coveredLength+=l;
					end = coveredLength/totalLength;
				
				// TODO: keySplines
				} else {
					// linear
					begin = (1./(vals.length-1))*(i);
					end = (1./(vals.length-1))*(i+1);
				}

				var step = {
					begin: begin,
					end:   end,
					from:  vals[i],
					to:    vals[i+1],
					interpolate: interpolate
				};
				steps.push(step);
			}
		}
		
		trace("Animation steps: "+steps );
	}
	
	function value( at:Float ) :Dynamic {
		var at2 = at%1.;
		for( step in steps ) {
			if( at2>=step.begin && at2<step.end ) {
				var t = (at-step.begin)/(step.end-step.begin);
				if( step.interpolate!=null ) {
					return step.interpolate( step.from, step.to, t );
				} else {
					return step.from;
				}
			}
		}
		return null;
	}
	
	function aaValue( t:Float ) :Dynamic {
		var mod = switch( accumulate ) {
			case Sum:
				t;
			case None:
				t%simpleDuration;
		}
		
		var cur = value( mod/simpleDuration );
		
		if( additive==Additive.Sum ) {
			var o = getFromTarget();
			trace("cur: "+cur+", o: "+o );
			if( o!=null ) cur = targetDefinition.add( o, cur );
			
		/* TODO
			var d = cur;
			if( lastValue!=null ) d = targetDefinition.subtract( cur, lastValue );
			var o = getFromTarget();
			trace("cur: "+cur+", o: "+o+", d: "+d );
			if( o!=null ) cur = targetDefinition.add( o, d );
		*/
		}
		
		lastValue = cur;
		return cur;
	}
	
	override function start( t:Float ) {
		if( peer==null ) throw("cannot create animation function, no peer set.");
		targetDefinition = peer.getTraitDefinition( attributeName );
		if( targetDefinition==null ) throw("no target attribute '"+attributeName+"' on "+peer );
		
		originalValue = getFromTarget();
		createSteps();
		super.start(t);
	}

	override function resetIteration( time:Float ) {
	trace("reset on "+peer+": "+getFromTarget() );
		resetOnTarget();
	}

}
