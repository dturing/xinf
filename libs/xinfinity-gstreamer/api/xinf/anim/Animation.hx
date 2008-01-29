/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;

class Animation extends TimedAttributeSetter {

	static var TRAITS = {
		additive: new EnumTrait<Additive>( Additive, Additive.Replace ),
		accumulate: new EnumTrait<Accumulate>( Accumulate, Accumulate.None ),
		calcMode: new EnumTrait<CalcMode>( CalcMode, CalcMode.Discrete ),
		
	//	keySplines: new StringTrait(),
	//	keyTimes: new TimeListTrait(),
		
		values: new StringTrait(),
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
    function get_calc_mode() :CalcMode { return getTrait("calc_mode",CalcMode); }
    function set_calc_mode( v:CalcMode ) :CalcMode { return setTrait("calcMode",v); }

    public var from(get_from,set_from):String;
    function get_from() :String { return getTrait("from",String); }
    function set_from( v:String ) :String { setTrait("from",v); reschedule(); return v; }

    public var to(get_to,set_to):String;
    function get_to() :String { return getTrait("to",String); }
    function set_to( v:String ) :String { setTrait("to",v); reschedule(); return v; }

}
