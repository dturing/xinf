/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;
import xinf.traits.TraitDefinition;
import xinf.ony.traits.FloatListTrait;
import xinf.ony.type.FloatList;
import xinf.anim.type.Additive;
import xinf.anim.type.Accumulate;
import xinf.anim.type.CalcMode;
import xinf.anim.type.ValuesTrait;
import xinf.anim.type.KeySplineTrait;
import xinf.anim.type.KeySplines;
import xinf.anim.type.KeySpline;
import xinf.anim.tools.Spline;

private typedef Step = { 
	begin:Float, end:Float, 
	from:Dynamic, to:Dynamic,
	interpolate:Dynamic->Dynamic->Float->Dynamic,
	spline:KeySpline
};

class Animation extends TimedAttributeSetter {

	static var TRAITS = {
		additive: new EnumTrait<Additive>( Additive, Additive.Replace ),
		accumulate: new EnumTrait<Accumulate>( Accumulate, Accumulate.None ),
		calcMode: new EnumTrait<CalcMode>( CalcMode, CalcMode.Linear ),
		
		keySplines: new KeySplineTrait(),
		keyTimes: new FloatListTrait(),
		
		values: new ValuesTrait(),
		from: new StringTrait(),
		to: new StringTrait(),
		by: new StringTrait(),
	};

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
	function set_values( v:Array<String> ) :Array<String> { setTrait("values",v); return v; }

	public var from(get_from,set_from):String;
	function get_from() :String { return getTrait("from",String); }
	function set_from( v:String ) :String { setTrait("from",v); return v; }

	public var to(get_to,set_to):String;
	function get_to() :String { return getStyleTrait("to",String); }
	function set_to( v:String ) :String { setStyleTrait("to",v); return v; }

	public var by(get_by,set_by):String;
	function get_by() :String { return getStyleTrait("by",String); }
	function set_by( v:String ) :String { setStyleTrait("by",v); return v; }

	public var keyTimes(get_keyTimes,set_keyTimes):FloatList;
	function get_keyTimes() :FloatList { return getStyleTrait("keyTimes",FloatList); }
	function set_keyTimes( v:FloatList ) :FloatList { setStyleTrait("keyTimes",v); return v; }

	public var keySplines(get_keySplines,set_keySplines):KeySplines;
	function get_keySplines() :KeySplines { return getStyleTrait("keySplines",KeySplines); }
	function set_keySplines( v:KeySplines ) :KeySplines { setStyleTrait("keySplines",v); return v; }

	var steps:Array<Step>;
	var originalValue:Dynamic;
	var targetDefinition:TraitDefinition;
	
	function fromDynamic( value:Dynamic ) :Dynamic {
		return targetDefinition.fromDynamic(value);
	}
	
	function createSteps() :Void {
		steps = new Array<Step>();
		
		var interpolate = null;
		if( calcMode != CalcMode.Discrete ) { 
			interpolate = targetDefinition.interpolate;
		}
		
		var vals;
		
		if( from!=null ) {
			if( to!=null ) {
				vals = [ fromDynamic(from), fromDynamic(to) ];
			} else if( by!=null ) {
				vals = [ fromDynamic(from), 
					targetDefinition.add( fromDynamic(from), fromDynamic(by) ) ];
			} else {
				trace("invalid animation: only from is given");
				return;
			}
		} else if( by!=null ) {
			vals = [ originalValue, targetDefinition.add(originalValue,fromDynamic(by)) ];
		} else if( to!=null ) {
			vals = [ originalValue, fromDynamic(to) ]; // FIXME: 0, not targetDefault...
		} else {
			vals = new Array<Dynamic>();
			for( v in values ) {
				vals.push( fromDynamic(v) );
			}
		}

		var vals2 = new Array<Dynamic>();
		for( val in vals ) {
			vals2.push( resolve(attributeName,val) );
		}
		vals=vals2;
		
		var times:Array<Float> = null;
		if( keyTimes!=null ) times = keyTimes.list;
		
		var splines:Array<KeySpline> = null;
		if( calcMode==CalcMode.Spline && keySplines!=null ) splines = keySplines.list;
		
		var totalLength:Null<Float> = null;
		if( calcMode == CalcMode.Paced ) {
			totalLength=0.;
			for( i in 0...(vals.length-1) ) {
				totalLength += targetDefinition.distance( vals[i], vals[i+1] );
			}
		} else if( times==null ) {
			// setup linear keyTimes
			times = new Array<Float>();
			for( i in 0...vals.length )
				times.push( (1./(vals.length-1))*(i) );
		}

		if( vals.length==1 ) {
			var v = vals[0];
			var step = {
				begin: 0.,
				end:   1.,
				from:  v,
				to:	v,
				interpolate: null,
				spline: null
			};
			steps.push(step);
		} else {
			var coveredLength = 0.;
			for( i in 0...(vals.length-1) ) {
				var begin = 0.;
				var end = 0.;
				var spline = null;
				if( totalLength!=null ) {
					// paced
					var l = targetDefinition.distance( vals[i], vals[i+1] );
					begin = coveredLength/totalLength;
					coveredLength+=l;
					end = coveredLength/totalLength;
				} else {
					begin = times[i];
					end = times[i+1];
					if( splines!=null ) {
						spline = splines[i];
					} else {
						// linear
					}
				}

				var step = {
					begin: begin,
					end:   end,
					from:  vals[i],
					to:	vals[i+1],
					interpolate: interpolate,
					spline: spline,
				};
				steps.push(step);
			}
		}
		
//		trace("Animation steps: "+steps );
	}
	
	function value( at:Float ) :Dynamic {
		var at2 = at%1.;
		for( step in steps ) {
			if( at2>=step.begin && at2<=step.end ) {
				var t = (at-step.begin)/(step.end-step.begin);
				if( step.interpolate!=null ) {
					if( step.spline!=null ) {
//						trace("at("+t+"): "+step.spline.yAtX(t));
						var ofs = Math.floor(t);
						return step.interpolate( step.from, step.to,
							ofs+step.spline.yAtX( t%1. ) );
					} else 
						return step.interpolate( step.from, step.to, t );
				} else {
					return step.from;
				}
			} else if( at<step.begin ) {
				return step.from;
			} else {
				return step.to;
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

		return additiveValue( value( mod/simpleDuration ) );
	}
	
	function additiveValue( v:Dynamic ) {
		if( additive==Additive.Sum ) {
			var o = getFromTarget();
			if( o!=null ) v = targetDefinition.add( o, v );
		}
		return v;
	}
	
	override function start( t:Float ) {
//	throw("Start "+this+" @ "+t );
		if( peer==null ) throw("cannot create animation function, no peer set.");
		if( attributeName==null ) throw("cannot create animation function, no attributeName set.");
		targetDefinition = peer.getTraitDefinition( attributeName );
		if( targetDefinition==null ) {
			trace("no target attribute '"+attributeName+"' on "+peer );
			return;
		}
		originalValue = getFromTarget();
		createSteps();
		super.start(t);
	}

	override function resetIteration( time:Float ) {
	/* FIXME maybe?
		if( additive==Additive.Sum ) {
			resetOnTarget();
		}
		*/
	}

}
