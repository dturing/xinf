/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import xinf.anim.TimeTrait;
import xinf.anim.Time;
import haxe.PosInfos;

class TestTime extends haxe.unit.TestCase {
	static var trait = new TimeTrait();
	
	function assertTime( a:Time, b:Time, ?c:PosInfos ) {
		currentTest.done = true;
		trace(" --> test "+a+" == "+b );
		switch( a ) {
			case Offset(ofs):
				switch(b) {
					case Offset(ofs2):
						if( ofs==ofs2 ) return;
					default:
				}
			case SyncBase(id,end,ofs):	
				switch(b) {
					case SyncBase(id2,end2,ofs2):
						if( id==id2 && end==end2 && ofs==ofs2 )
							return;
					default:
				}
			case Event(id,event,ofs):	
				switch(b) {
					case Event(id2,event2,ofs2):
						if( id==id2 && event==event2 && ofs==ofs2 )
							return;
					default:
				}
			case WallClock(date):
				switch(b) {
					case WallClock(date2):
						if( date.getTime()==date2.getTime() )
							return;
					default:
				}
			default:
		}
		
		currentTest.success = false;
		currentTest.error = "expected "+b+", but was "+a;
		currentTest.posInfos = c;
		throw currentTest;
	}
	
	function dont_testOffset() {
		assertTime(
			trait.parse("+23"),
			Time.Offset(23.));
		assertTime(
			trait.parse("23"),
			Time.Offset(23.));
		assertTime(
			trait.parse("-23"),
			Time.Offset(-23.));
		assertTime(
			trait.parse("+23.42"),
			Time.Offset(23.42));
		assertTime(
			trait.parse("23.42"),
			Time.Offset(23.42));
		assertTime(
			trait.parse("-23.42"),
			Time.Offset(-23.42));

		assertTime(
			trait.parse("+ 23"),
			Time.Offset(23.));
		assertTime(
			trait.parse(" +23"),
			Time.Offset(23.));
		assertTime(
			trait.parse(" + 23"),
			Time.Offset(23.));
		assertTime(
			trait.parse("\t\r\n+\t\r\n23\t\r\n"),
			Time.Offset(23.));

		assertTime(
			trait.parse("-10.1h"),
			Time.Offset(-36360));
		assertTime(
			trait.parse("-10.1min"),
			Time.Offset(-606));
		assertTime(
			trait.parse("-10.1s"),
			Time.Offset(-10.1));
		assertTime(
			trait.parse("-10.1ms"),
			Time.Offset(-.0101));
	}
	
	function dont_testSyncbase() {
		assertTime(
			trait.parse(".begin"),
			Time.SyncBase("",false,0));
		assertTime(
			trait.parse(".end"),
			Time.SyncBase("",true,0));
			
		assertTime(
			trait.parse("foo.begin"),
			Time.SyncBase("foo",false,0));
		assertTime(
			trait.parse("foo.end"),
			Time.SyncBase("foo",true,0));
		assertTime(
			trait.parse("foo.begin+23"),
			Time.SyncBase("foo",false,23));
		assertTime(
			trait.parse("foo.begin-23"),
			Time.SyncBase("foo",false,-23));

		assertTime(
			trait.parse("foo.begin+1h"),
			Time.SyncBase("foo",false,3600));
		assertTime(
			trait.parse("foo.begin+1min"),
			Time.SyncBase("foo",false,60));
		assertTime(
			trait.parse("foo.begin+1s"),
			Time.SyncBase("foo",false,1));
		assertTime(
			trait.parse("foo.begin+1ms"),
			Time.SyncBase("foo",false,.001));

		assertTime(
			trait.parse("foo.begin+1.5h"),
			Time.SyncBase("foo",false,5400));
		assertTime(
			trait.parse("foo.begin+1.5min"),
			Time.SyncBase("foo",false,90));
		assertTime(
			trait.parse("foo.begin+1.5s"),
			Time.SyncBase("foo",false,1.5));
		assertTime(
			trait.parse("foo.begin+1.5ms"),
			Time.SyncBase("foo",false,.0015));
	}

	function dont_testEvent() {
		assertTime(
			trait.parse("foo.click"),
			Time.Event("foo","click",0));
		assertTime(
			trait.parse("foo.mouseDown-1.5min"),
			Time.Event("foo","mouseDown",-90));
	}
	
	function testWallclock() {
	/*
		assertTime(
			trait.parse("wallclock(1976-05-05)"),
			Time.WallClock(Date.fromString("1976-05-05")));
			
		assertTime(
			trait.parse("wallclock(12:34:56)"),
			Time.WallClock(Date.fromString("1970-01-01 12:34:56")));
		assertTime(
			trait.parse("wallclock(12:34:56Z)"),
			Time.WallClock(Date.fromString("1970-01-01 12:34:56")));
		assertTime(
			trait.parse("wallclock(08:00:00+00:00)"),
			Time.WallClock(Date.fromString("1970-01-01 08:00:00")));
			*/
		assertTime(
			trait.parse("wallclock(1976-05-05T16:20:23)"),
			Time.WallClock(Date.fromString("1976-05-05 16:20:23")));
	}
}

class Test {
	public static function main() {
		var r = new haxe.unit.TestRunner();
		r.add( new TestTime() );
		r.run();
	}
}
