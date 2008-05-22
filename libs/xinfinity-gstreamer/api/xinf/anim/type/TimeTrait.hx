/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.TypedTrait;

class TimeTrait extends TypedTrait<Time> {

	var def:Time;
	
	public function new( ?def:Time ) {
		super( Time );
		if( def==null ) def = Time.Indefinite;
		this.def=def;
	}

	override public function getDefault() :Dynamic {
		return def;
	}

	override public function parse( value:String ) :Dynamic {
		var parts = value.split(";");
		if( parts.length>1 ) {
			var l = new List<Time>();
			for( part in parts ) {
				l.add( parseSingle(part) );
			}
			return Time.List(l);
		} else {
			return parseSingle(value);
		}
		return null;
	}

	static var offset = ~/^([\r\n\t ]*[\+\-]?[\r\n\t ]*[0-9\.]+[\r\n\t ]*(h|min|s|ms)?)$/;
	static var syncbase = ~/^(.+)?\.(begin|end)[\r\n\t ]*([\+\-][\r\n\t ]*.+)?$/;
	static var event = ~/^(.+)?\.([^\+\-0-9]+)[\r\n\t ]*([\+\-][\r\n\t ]*.+)?$/;
	static var wallclock = ~/^wallclock\([\r\n\t ]*(.+)[\r\n\t ]*\)$/;
	static function parseSingle( value:String ) :Time {
		value = StringTools.trim(value);
		
		if( value=="indefinite" ) {
			return Time.Indefinite;
			
		} else if( offset.match(value ) ) {
			return Time.Offset( parseClockValue(offset.matched(1)) );
			
		} else if( wallclock.match(value ) ) {
			return Time.WallClock( parseWallclockValue(wallclock.matched(1)) );
			
		} else if( syncbase.match(value) ) {
			var ofs=parseClockValue(syncbase.matched(3));
			return Time.SyncBase(
				syncbase.matched(1),syncbase.matched(2)=="end",ofs);
				
		} else if( event.match(value) ) {
			var ofs=parseClockValue(event.matched(3));
			return Time.Event(
				event.matched(1),event.matched(2),ofs);
				
		} else {
			throw("unmatched time specification: '"+value+"'");
		}
		
		return null;
	}
	
	static var dateTime = ~/^([0-9\-]*)T(.*)$/;
	static var date = ~/^([0-9][0-9][0-9][0-9])\-([01][0-9])\-([0-3][0-9])$/;
	static var time = ~/^([0-2][0-9]):([0-5][0-9])(:([0-5][0-9](\.([0-9]*))?))?(Z|([\+\-][0-2][0-9]):([0-5][0-9]))?$/;
	static function parseWallclockValue( value:String ) :Date {
		if( dateTime.match(value) ) {
			var d = parseDate(dateTime.matched(1));
			var t = parseTime(d,dateTime.matched(2));
//			trace("date: "+d+", time: "+t );
			return t;
			
		} else if( date.match(value) ) {
			return parseDate(value);
			
		} else if( time.match(value) ) {
			return parseTime( Date.now(), value );
			
		} else {
			throw("No Wallclock match: "+value );
		}
		return Date.fromTime(0);
	}
	
	static function parseDate( value:String ) :Date {
		if( date.match(value) ) {
			var years = Std.parseInt( date.matched(1) );
			var months = Std.parseInt( date.matched(2) )-1;
			var days = Std.parseInt( date.matched(3) );
			return new Date( years, months, days, 0, 0, 0 );
		}
		return Date.fromTime(0);
	}

	static function parseTime( today:Date, value:String ) :Date {
		if( time.match(value) ) {
			var hours = Std.parseInt( time.matched(1) );
			var minutes = Std.parseInt( time.matched(2) );
			var seconds = Std.parseInt( time.matched(4) );
			var fraction = Std.parseInt( time.matched(6) );
			var zone = time.matched(7);
			var offset = if( zone=="Z" ) 0
						 else 60*(Std.parseInt(time.matched(8))*60)+Std.parseInt(time.matched(9));
			var r = new Date(today.getFullYear(),today.getMonth(),today.getDate(),hours,minutes,seconds);
			var d = Date.fromTime( r.getTime() + fraction + (offset*1000) );
			return d;
		}
		return Date.fromTime(0);
	}

	static var timeCount = ~/^[\r\n\t ]*(\+|\-)?[\r\n\t ]*([0-9\.]+)[\r\n\t ]*(h|min|s|ms)?[\r\n\t ]*$/;
	static var clock = ~/^[\r\n\t ]*(([0-9]+):)?([0-5][0-9]):([0-5][0-9])(\.[0-9]*)?[\r\n\t ]*$/;
	public static function parseClockValue( value:String ) :Null<Float> {
		// TODO: 01:30.25 = 1min30s250ms
		if( value.length==0 ) {
			return 0;
		} else if( timeCount.match(value) ) {
			var v = Std.parseFloat( timeCount.matched(1)+timeCount.matched(2) );
			var metric = timeCount.matched(3);
			switch( metric ) {
				case "h": v*=3600;
				case "min": v*=60;
				case "ms": v/=1000;
			}
			return v;
		} else if( clock.match(value) ) {
			var h = Std.parseInt(clock.matched(2));
			var m = Std.parseInt(clock.matched(3));
			var s = Std.parseInt(clock.matched(4));
			var f = Std.parseFloat(clock.matched(5));
			return( (60*((60*h)+m))+s+f );
		} else {
			throw("invalid clock value: '"+value+"'");
		}
		return null;
	}
}
