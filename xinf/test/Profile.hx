/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.test;

class Profile {
	public static var profiles = new Hash<Profile>();
	
	public static function before( name:String ) {
		var p = profiles.get(name);
		if( p==null ) {
			p = new Profile();
			profiles.set(name,p);
		}
		p._before();
	}

	public static function after( name:String ) {
		var p = profiles.get(name);
		p._after();
	}
	
	public static function dump() {
		for( name in profiles.keys() ) {
			profiles.get(name)._dump(name);
		}
	}
	
	
	var t:Float;
	var acc:Float;
	var n:Int;

	public function new() {
		t=acc=0.;
		n=0;
	}

	public function _before() {
		#if neko
		t = neko.Sys.time();
		#end
	}

	public function _after() {
		#if neko
		var t2 = neko.Sys.time();
		var d = t2-t;
		acc += d;
		n++;
		#end
	}
	
	public function _dump( name:String ) {
		#if neko
		var t = Math.round( (acc/n)*10000 )/10;
		neko.Lib.print( ""+n+"x"+StringTools.lpad( name, " ", 15 )+" @ "+t+"ms\n" );
		acc=0; n=0;
		#else 
		trace("Profiling is only supported for the neko platform.");
		#end
	}
}
