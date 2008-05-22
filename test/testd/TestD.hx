/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package testd;

class TestD {
	
	public static var width = 480;
	public static var height = 360;

	public static var displayName = ":10.0";
	public static var resultDir = "results";
	
	static function assureResultDir() {
		// assure result directory exists
		if( !neko.FileSystem.exists( resultDir ) ) {
			neko.FileSystem.createDirectory( resultDir );
		}
		if( !neko.FileSystem.isDirectory( resultDir ) ) {
			throw( "test result directory '"+resultDir+"' exists but is not a directory" );
		}
	}
	
	static function log( test:String, platform:String, message:String ) :Void {
		var out = neko.io.File.append( resultDir+"/"+test+"-"+platform+"-log.txt", false );
		out.write( message+"\n");
		out.close();
	}

	static function screenshot( test:String, platform:String ) :Void {
		var filename = resultDir+"/"+test+"-"+platform+".pnm";
		var exitCode = neko.Sys.command("xwd -display "+displayName+" -nobdrs -root | xwdtopnm | pnmcut -left 1 -top 1 -width "+width+" -height "+height+" > "+filename );
	}
	
	static function main() {
		assureResultDir();
		
		var r = new neko.net.RemotingServer();
		r.addObject( "test", TestD );
		if( r.handleRequest() ) return;
		
		neko.Lib.print("xinf testd - not for human consumption.\n");
	}
}
