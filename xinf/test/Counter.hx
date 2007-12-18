/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

class Counter {
	public static var profiles = new Hash<Int>();
	
	public static function count( name:String ) {
		var p:Null<Int> = profiles.get(name);
		if( p==null ) p=0;
		p++;
		profiles.set(name,p);
	}
	
	public static function dump() {
		var frames = profiles.get("frames");
		if( frames==null ) frames=1;
		
		for( name in profiles.keys() ) {
			#if neko
			if( name!="frames" )
				neko.Lib.print( StringTools.lpad( name, " ", 15 )
					+": "+(profiles.get(name)/frames)+"\n" );
			#end
		}
	}
	
	public static function reset() {
		profiles = new Hash<Int>();
	}
	
}
