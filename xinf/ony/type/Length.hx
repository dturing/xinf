/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.type;

/**
	An SVG-like Length value, a distance measurement.

	This is currently mostly a stub, to allow for 
	parsing length values with units. Conversion
	is not correct.
	
	Proper documentation will follow here when it
	is properly implemented.

	$SVG types#DataTypeLength SVG Length$
	$SVG coords#Units SVG Units$
*/

/* see also:
	http://www.w3.org/TR/SVG11/types.html#InterfaceSVGLength
	http://www.w3.org/TR/REC-CSS2/syndata.html
*/
class Length {
	// Length Unit Types.. originally numbers 0..10
	public static var TYPE_UNKNOWN:String		= "??";
	public static var TYPE_NUMBER:String		= "";
	public static var TYPE_PERCENTAGE:String	= "%";
	public static var TYPE_EMS:String		= "em";
	public static var TYPE_EXS:String		= "ex";
	public static var TYPE_PX:String		= "px";
	public static var TYPE_CM:String		= "cm";
	public static var TYPE_MM:String		= "mm";
	public static var TYPE_IN:String		= "in";
	public static var TYPE_PT:String		= "pt";
	public static var TYPE_PC:String		= "pc";

	public var unitType(getUnitType,null):	String;
	public var value(getValue,setValue):	Float;
	public var valueInSpecifiedUnits:	Float;
	public var DOMString(getDOMString,setDOMString): String;

	static var pixSize : Float = 0.28; // in mm -> 90 dpi, * 25.4mm/inch (1/90*25.4)

	private var orig:{value:Float, type:String};

	public function new( ?s:String, ?v:Float ) {
		if(s != null)
			setDOMString(s);
		if(v != null) {
			unitType = TYPE_NUMBER;
			value = v;
		}
	}
	
	public function newValueSpecifiedUnits ( unitType : String, i:Float ):Void {
		if(typeValid(unitType) && i != Math.NaN)
			this.unitType = unitType;
		else
			unitType = TYPE_UNKNOWN;
		value = i;
		orig = {
			value: i,
			type: unitType
		};
	}

	/*
	* in: inches -- 1 inch is equal to 2.54 centimeters.
	* cm: centimeters
	* mm: millimeters
	* pt: points -- the points used by CSS2 are equal to 1/72th of an inch.
	* pc: picas -- 1 pica is equal to 12 points.
	* px: pixels
	*	For reading at arm's length, 1px thus corresponds to about 0.28 mm
	*	(1/90 inch). When printed on a laser printer, meant for reading at a
	*	little less than arm's length (55 cm, 21 inches), 1px is about 0.21 mm.
	*	On a 300 dots-per-inch (dpi) printer, that may be rounded up to 3 dots
	*	(0.25 mm); on a 600 dpi printer, it can be rounded to 5 dots.
	*/
	public function convertToSpecifiedUnits ( newType : String, ?data:Float ) :Bool {
		if(newType == TYPE_EMS || newType == TYPE_EXS)
			return false;

		// conversion can't be done
		var rv : Bool = false;
		switch(this.unitType) {
		case TYPE_NUMBER: rv = true;
		case TYPE_PERCENTAGE:
			if(data == null) return false;
			value *= data;
			rv = true;
		case TYPE_EMS:
		case TYPE_EXS:
		case TYPE_PX:
			switch(newType) {
			case TYPE_NUMBER: rv = true; // TODO dpi convert
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true;
			case TYPE_CM: rv = true; value = value * pixSize / 10;
			case TYPE_MM: rv = true; value *= pixSize;
			case TYPE_IN: rv = true; value *= (pixSize / 25.4);
			case TYPE_PT: rv = true; value *= (pixSize * 2.834645669291399); // 72 PT/25.4 mm
			case TYPE_PC: rv = true; value *= (pixSize * 0.23622047244); // 6 PC/25.4 mm
			default:
			}
		case TYPE_CM:
			switch(newType) {
			case TYPE_NUMBER: rv = true;
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true; value = value * 10 / pixSize;
			case TYPE_CM: rv = true;
			case TYPE_MM: rv = true; value = value * 10;
			case TYPE_IN: rv = true; value *= (1/2.54);
			case TYPE_PT: rv = true; value = value * (1/2.54) * 72;
			case TYPE_PC: rv = true; value = value * (1/2.54) * 6;
			default:
			}
		case TYPE_MM:
			switch(newType) {
			case TYPE_NUMBER: rv = true;
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true; value /= pixSize;
			case TYPE_CM: rv = true; value *= 10;
			case TYPE_MM: rv = true;
			case TYPE_IN: rv = true; value = value * (1/2.54) / 10;
			case TYPE_PT: rv = true; value = value * (1/2.54) * 7.2;
			case TYPE_PC: rv = true; value = value * (1/2.54) * 0.6;
			default:
			}
		case TYPE_IN:
			switch(newType) {
			case TYPE_NUMBER: rv = true;
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true; value *= 25.4 / pixSize;
			case TYPE_CM: rv = true; value *= 2.54;
			case TYPE_MM: rv = true; value *= 25.4;
			case TYPE_IN: rv = true;
			case TYPE_PT: rv = true; value *= 72;
			case TYPE_PC: rv = true; value *= 6;
			default:
			}
		case TYPE_PT:
			switch(newType) {
			case TYPE_NUMBER: rv = true;
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true; value /= 2.834645669291399 / pixSize;
			case TYPE_CM: rv = true; value /= 28.34645669291399;
			case TYPE_MM: rv = true; value /= 2.834645669291399;
			case TYPE_IN: rv = true; value /= 72;
			case TYPE_PT: rv = true;
			case TYPE_PC: rv = true; value /= 12;
			default:
			}
		case TYPE_PC:
			switch(newType) {
			case TYPE_NUMBER: rv = true;
			case TYPE_PERCENTAGE:
				if(data != null && data != 0) {
					value = value / data;
					rv = true;
				}
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX: rv = true; value /= 0.23622047244 / pixSize;
			case TYPE_CM: rv = true; value /= 2.3622047244;
			case TYPE_MM: rv = true; value /= 0.23622047244;
			case TYPE_IN: rv = true; value /= 6;
			case TYPE_PT: rv = true; value *= 12;
			case TYPE_PC: rv = true;
			default:
			}
		default:
		}
		if(rv)
			unitType = newType;
		return rv;
	}



	public function getUnitType():String {
		return unitType;
	}
	public function getValue():Float {
		return value;
	}
	public function setValue(v:Float):Float {
		value = v;
		return v;
	}

	public function toString() : String {
		return "("+getDOMString()+")";
	}
	public function getDOMString() : String {
		if(unitType == TYPE_UNKNOWN)
			return "";
		var v = value;
		if( v>.001 ) Math.round(value*100)/100;
		return(Std.string( v ) + unitType);
	}
	public function setDOMString(s:String) : String {
		
		// FIXME implement other units than number!
		
		var num : Float = 0.0;
		var unit : String = TYPE_UNKNOWN;

		if(s == null || s.length == 0)
			return s;
		s = StringTools.trim(s);
		num = Std.parseFloat(s);
		if(num != Math.NaN) {
			unit = TYPE_NUMBER;
			var r:EReg = ~/([a-z%]+)/;
			try {
				r.match(s);
				if(typeValid(r.matched(0)))
					unit = r.matched(0);
			}
			catch(e:Dynamic) {}
		}
		newValueSpecifiedUnits(unit, num);
		return s;
	}

	private function typeValid(ut:String) : Bool {
		switch(ut) {
			case TYPE_NUMBER:
			case TYPE_PERCENTAGE:
			case TYPE_EMS:
			case TYPE_EXS:
			case TYPE_PX:
			case TYPE_CM:
			case TYPE_MM:
			case TYPE_IN:
			case TYPE_PT:
			case TYPE_PC:
			default:
				return false;
		}
		return true;
	}
}
